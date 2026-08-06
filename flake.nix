{
  description = "Static CIS-aligned validation for NixOS evaluations";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    nixosModules = rec {
      nixos-cis-validator = import ./modules;
      default = nixos-cis-validator;
    };

    checks = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
        inherit (nixpkgs) lib;

        mkSystem = validatorConfig:
          lib.nixosSystem {
            inherit system;
            modules = [
              self.nixosModules.default
              ({...}: {
                boot.loader.grub.enable = false;
                fileSystems."/" = {
                  device = "/dev/disk/by-label/nixos";
                  fsType = "ext4";
                };
                networking.hostName = "cis-validator-test";
                system.stateVersion = "26.05";

                security.cisValidator = validatorConfig;
              })
            ];
          };

        compliant = mkSystem {
          enable = true;
          failureMode = "error";
          defaultRuleEnable = false;
          rules."1.5.8".enable = true;
        };

        reportOnly = mkSystem {
          enable = true;
          failureMode = "report";
          defaultRuleEnable = false;
          rules."5.1.20".enable = true;
        };

        warning = mkSystem {
          enable = true;
          failureMode = "warn";
          defaultRuleEnable = false;
          rules."5.1.20".enable = true;
        };

        blocking = mkSystem {
          enable = true;
          failureMode = "error";
          defaultRuleEnable = false;
          rules."5.1.20".enable = true;
        };

        catalog = mkSystem {
          enable = true;
          failureMode = "report";
        };

        blockingEvaluation = builtins.tryEval blocking.config.system.build.toplevel.drvPath;
      in {
        compliant =
          pkgs.runCommand "cis-validator-compliant-check" {
            nativeBuildInputs = [pkgs.jq];
            report = compliant.config.system.build.cisValidationReport;
          } ''
            jq -e '
              .schemaVersion == 3 and
              .profile.id == "ubuntu-24.04-l1-server" and
              .profile.alignment.certified == false and
              .summary.enabledRules == 1 and
              .summary.violations == 0 and
              (.rules | map(select(.source.recommendation == "1.5.8"))[0].status) == "pass"
            ' "$report" >/dev/null
            touch "$out"
          '';

        report-only =
          pkgs.runCommand "cis-validator-report-only-check" {
            nativeBuildInputs = [pkgs.jq];
            report = reportOnly.config.system.build.cisValidationReport;
          } ''
            jq -e '
              .failureMode == "report" and
              .profile.source.version == "2.0.0" and
              .profile.source.recommendations == 258 and
              .summary.violations == 1 and
              (.rules | map(select(.source.recommendation == "5.1.20"))[0].status) == "fail" and
              (.rules | map(select(.source.recommendation == "5.1.20"))[0].evidence.actual) == "prohibit-password"
            ' "$report" >/dev/null
            touch "$out"
          '';

        catalog =
          pkgs.runCommand "cis-validator-catalog-check" {
            nativeBuildInputs = [pkgs.jq];
            report = catalog.config.system.build.cisValidationReport;
          } ''
            jq -e '
              .summary.benchmarkRecommendations == 258 and
              .summary.sourceAutomated == 246 and
              .summary.sourceManual == 12 and
              (.rules | length) == 258 and
              ([.rules[].source.recommendation] | unique | length) == 258 and
              (.summary.staticallyAssessed + .summary.runtimeRequired +
               .summary.notApplicable + .summary.unsupported + .summary.disabled) == 258
            ' "$report" >/dev/null
            touch "$out"
          '';

        warning = assert lib.any (message: lib.hasInfix "CIS 5.1.20" message) warning.config.warnings;
          pkgs.runCommand "cis-validator-warning-check" {} ''
            touch "$out"
          '';

        error = assert !blockingEvaluation.success;
          pkgs.runCommand "cis-validator-error-check" {} ''
            touch "$out"
          '';
      }
    );

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
