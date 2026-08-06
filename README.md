# nixos-cis-validator

`nixos-cis-validator` is a NixOS module that checks a fully merged NixOS
evaluation against a CIS-aligned rule catalog. It produces a JSON build
artifact and can optionally turn static violations into NixOS warnings or
build-blocking assertions.

The included profiles are NixOS-native mappings of six Level 1 Server
benchmarks:

| Profile identifier | Source benchmark | Recommendations |
| --- | --- | ---: |
| `ubuntu-24.04-l1-server` | CIS Ubuntu Linux 24.04 LTS v2.0.0 | 258 |
| `debian-13-l1-server` | CIS Debian Linux 13 v1.0.0 | 262 |
| `almalinux-10-l1-server` | CIS AlmaLinux OS 10 v1.0.0 | 248 |
| `rhel-10-l1-server` | CIS Red Hat Enterprise Linux 10 v1.0.1 | 248 |
| `rocky-linux-10-l1-server` | CIS Rocky Linux 10 v1.0.0 | 248 |
| `amazon-linux-2-l1-server` | CIS Amazon Linux 2 v4.0.0 | 225 |

The mappings are derived work and do not claim CIS conformance or
certification. See the [benchmark mapping policy](docs/benchmark-mapping.md)
for the precise scope.

## Add the module to a flake

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-cis-validator.url = "github:ruiiiijiiiiang/nixos-cis-validator";
  };

  outputs = {
    nixpkgs,
    nixos-cis-validator,
    ...
  }: {
    nixosConfigurations.my-host = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-cis-validator.nixosModules.default
        {
          security.cisValidator = {
            enable = true;
            profile = "ubuntu-24.04-l1-server";
            failureMode = "warn";
          };
        }
      ];
    };
  };
}
```

Importing the module does not enable validation. Set
`security.cisValidator.enable = true` on each host to check. The profile option
defaults to `"ubuntu-24.04-l1-server"`; select any identifier from the table
above to use another baseline. Identifiers include the distribution version so
updating a benchmark cannot silently change the selected rule set.

## Failure modes

`security.cisValidator.failureMode` accepts:

- `"report"`: record violations without warnings or failed assertions.
- `"warn"`: emit NixOS evaluation warnings and produce the report. This is
  the default.
- `"error"`: add failed NixOS assertions, so static violations block the
  system build.

Only recommendations with a deterministic static evaluator can violate.
Runtime-required, not-applicable, unsupported, and disabled recommendations
are reported but never warn or block a build.

All catalog recommendations are enabled by default. They can be disabled by
CIS recommendation number:

```nix
security.cisValidator.rules."1.1.1.1".enable = false;
```

For an allow-list rollout, disable rules globally and enable selected rules:

```nix
security.cisValidator = {
  defaultRuleEnable = false;
  rules."1.5.8".enable = true;
  rules."5.1.20".enable = true;
};
```

## Build the report

The report is exposed as `system.build.cisValidationReport`:

```console
nix build \
  '.#nixosConfigurations.my-host.config.system.build.cisValidationReport'
jq . result
```

Every recommendation in the selected profile has a status of `pass`, `fail`,
`not-assessed`, `not-applicable`, or `disabled`. It also records the source
recommendation, source assessment type, NixOS applicability, validation phase,
evidence, and NixOS-specific remediation. A summary reports catalog, static,
runtime, not-applicable, and unsupported counts.

Abbreviated report shape:

```json
{
  "schemaVersion": 3,
  "failureMode": "warn",
  "profile": {
    "id": "ubuntu-24.04-l1-server",
    "source": {
      "version": "2.0.0",
      "recommendations": 258
    },
    "alignment": {
      "status": "derived",
      "certified": false
    }
  },
  "summary": {
    "benchmarkRecommendations": 258,
    "sourceAutomated": 246,
    "sourceManual": 12,
    "sourceUnspecified": 0
  },
  "rules": []
}
```

Amazon Linux 2 v4.0.0 does not display Automated or Manual assessment labels
on its recommendation pages. Its 225 entries therefore report
`assessment = "unspecified"` and `summary.sourceUnspecified = 225`; the
validator does not invent source classifications.

## Development

Run formatting and all evaluation/report checks with:

```console
nix fmt
nix flake check
```
