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

        acceptedException = mkSystem {
          enable = true;
          failureMode = "error";
          defaultRuleEnable = false;
          rules."5.1.20" = {
            enable = true;
            failureMode = "report";
            justification = "Accepted by site policy for this test host.";
          };
        };

        selectiveBlocking = mkSystem {
          enable = true;
          failureMode = "report";
          defaultRuleEnable = false;
          rules."5.1.20" = {
            enable = true;
            failureMode = "error";
          };
        };

        invalidRule = mkSystem {
          enable = true;
          failureMode = "report";
          rules."999.999".failureMode = "error";
        };

        mkCatalogSystem = profile:
          mkSystem {
            enable = true;
            inherit profile;
            failureMode = "report";
          };

        ubuntuCatalog = mkCatalogSystem "ubuntu-24.04-l1-server";
        debianCatalog = mkCatalogSystem "debian-13-l1-server";
        almaLinuxCatalog = mkCatalogSystem "almalinux-10-l1-server";
        rhelCatalog = mkCatalogSystem "rhel-10-l1-server";
        rockyLinuxCatalog = mkCatalogSystem "rocky-linux-10-l1-server";
        amazonLinuxCatalog = mkCatalogSystem "amazon-linux-2-l1-server";

        blockingEvaluation = builtins.tryEval blocking.config.system.build.toplevel.drvPath;
        acceptedExceptionEvaluation = builtins.tryEval acceptedException.config.system.build.toplevel.drvPath;
        selectiveBlockingEvaluation = builtins.tryEval selectiveBlocking.config.system.build.toplevel.drvPath;
        invalidRuleEvaluation = builtins.tryEval invalidRule.config.system.build.toplevel.drvPath;
      in {
        compliant =
          pkgs.runCommand "cis-validator-compliant-check" {
            nativeBuildInputs = [pkgs.jq];
            report = compliant.config.system.build.cisValidationReport;
          } ''
            jq -e '
              .schemaVersion == 1 and
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
              .summary.warningViolations == 0 and
              .summary.blockingViolations == 0 and
              (.rules | map(select(.source.recommendation == "5.1.20"))[0].status) == "fail" and
              (.rules | map(select(.source.recommendation == "5.1.20"))[0].enforcement.inherited) == true and
              (.rules | map(select(.source.recommendation == "5.1.20"))[0].enforcement.effective) == "report" and
              (.rules | map(select(.source.recommendation == "5.1.20"))[0].evidence.actual) == "prohibit-password"
            ' "$report" >/dev/null
            touch "$out"
          '';

        catalog =
          pkgs.runCommand "cis-validator-catalog-check" {
            nativeBuildInputs = [pkgs.jq];
            ubuntuReport = ubuntuCatalog.config.system.build.cisValidationReport;
            debianReport = debianCatalog.config.system.build.cisValidationReport;
            almaLinuxReport = almaLinuxCatalog.config.system.build.cisValidationReport;
            rhelReport = rhelCatalog.config.system.build.cisValidationReport;
            rockyLinuxReport = rockyLinuxCatalog.config.system.build.cisValidationReport;
            amazonLinuxReport = amazonLinuxCatalog.config.system.build.cisValidationReport;
          } ''
            check_report() {
              report="$1"
              profile="$2"
              recommendations="$3"
              automated="$4"
              manual="$5"
              unspecified="$6"

              jq -e \
                --arg profile "$profile" \
                --argjson recommendations "$recommendations" \
                --argjson automated "$automated" \
                --argjson manual "$manual" \
                --argjson unspecified "$unspecified" '
                  .profile.id == $profile and
                  .profile.internal == null and
                  .summary.benchmarkRecommendations == $recommendations and
                  .summary.sourceAutomated == $automated and
                  .summary.sourceManual == $manual and
                  .summary.sourceUnspecified == $unspecified and
                  .summary.staticallyAssessed > 0 and
                  (.rules | length) == $recommendations and
                  ([.rules[].source.recommendation] | unique | length) == $recommendations and
                  (.summary.staticallyAssessed + .summary.runtimeRequired +
                   .summary.notApplicable + .summary.unsupported + .summary.disabled) == $recommendations
                ' "$report" >/dev/null
            }

            check_report "$ubuntuReport" ubuntu-24.04-l1-server 258 246 12 0
            check_report "$debianReport" debian-13-l1-server 262 249 13 0
            check_report "$almaLinuxReport" almalinux-10-l1-server 248 231 17 0
            check_report "$rhelReport" rhel-10-l1-server 248 231 17 0
            check_report "$rockyLinuxReport" rocky-linux-10-l1-server 248 231 17 0
            check_report "$amazonLinuxReport" amazon-linux-2-l1-server 225 0 0 225
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

        accepted-exception = assert acceptedExceptionEvaluation.success;
          pkgs.runCommand "cis-validator-accepted-exception-check" {
            nativeBuildInputs = [pkgs.jq];
            report = acceptedException.config.system.build.cisValidationReport;
          } ''
            jq -e '
              .failureMode == "error" and
              .summary.violations == 1 and
              .summary.blockingViolations == 0 and
              (.rules | map(select(.source.recommendation == "5.1.20"))[0].enforcement.configured) == "report" and
              (.rules | map(select(.source.recommendation == "5.1.20"))[0].enforcement.effective) == "report" and
              (.rules | map(select(.source.recommendation == "5.1.20"))[0].enforcement.justification) == "Accepted by site policy for this test host."
            ' "$report" >/dev/null
            touch "$out"
          '';

        selective-error = assert !selectiveBlockingEvaluation.success;
          pkgs.runCommand "cis-validator-selective-error-check" {} ''
            touch "$out"
          '';

        invalid-rule = assert !invalidRuleEvaluation.success;
          pkgs.runCommand "cis-validator-invalid-rule-check" {} ''
            touch "$out"
          '';
      }
    );

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
