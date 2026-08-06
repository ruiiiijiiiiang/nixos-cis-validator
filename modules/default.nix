{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption types;

  cfg = config.security.cisValidator;

  profiles = import ./profiles;

  selectedProfile = profiles.${cfg.profile};
  evaluator = import ./evaluators {
    inherit config lib;
    profile = selectedProfile;
  };

  ruleConfig = cisId: cfg.rules.${cisId} or {};

  classify = entry:
    evaluator.mappings.${
      entry.cisId
    }
      or (
      if builtins.hasAttr entry.cisId evaluator.notApplicable
      then {
        applicability = "not-applicable";
        reason = evaluator.notApplicable.${entry.cisId};
        validation = {
          phase = "none";
          target = "ubuntu-specific";
        };
      }
      else if
        entry.assessment
        == "manual"
        || builtins.hasAttr entry.cisId evaluator.runtime
        || lib.any (prefix: lib.hasPrefix prefix entry.cisId) evaluator.runtimePrefixes
      then {
        applicability = "runtime";
        reason = evaluator.runtime.${entry.cisId} or "The source benchmark requires a manual assessment that cannot be proven from Nix evaluation.";
        validation = {
          phase = "runtime";
          target = "running-system";
        };
      }
      else {
        applicability = "unsupported";
        reason = "No reliable NixOS static evaluator has been implemented for this recommendation yet.";
        validation = {
          phase = "unavailable";
          target = "unmapped";
        };
      }
    );

  mkRule = entry: let
    result = classify entry;
    enabled = (ruleConfig entry.cisId).enable or cfg.defaultRuleEnable;
    status =
      if !enabled
      then "disabled"
      else if result ? passed
      then
        if result.passed
        then "pass"
        else "fail"
      else if result.applicability == "not-applicable"
      then "not-applicable"
      else "not-assessed";
  in {
    id = "cis-${lib.replaceStrings ["."] ["-"] entry.cisId}";
    inherit enabled status;
    inherit (entry) title assessment;
    inherit (result) applicability validation;
    description = result.description or "NixOS mapping for CIS recommendation ${entry.cisId}.";
    remediation = result.remediation or "Review this recommendation and its NixOS applicability before enforcement.";
    reason = result.reason or null;
    evidence = result.evidence or {};
    passed = result.passed or false;
    source = {
      recommendation = entry.cisId;
      mappingStatus =
        if result ? passed
        then "implemented"
        else "classified";
    };
  };

  allRules = map mkRule selectedProfile.catalog;
  enabledRules = builtins.filter (rule: rule.enabled) allRules;
  violations = builtins.filter (rule: rule.status == "fail") enabledRules;
  countStatus = status: builtins.length (builtins.filter (rule: rule.status == status) allRules);
  publicRules = map (rule: builtins.removeAttrs rule ["passed"]) allRules;

  formatViolation = rule: "[nixos-cis-validator] CIS ${rule.source.recommendation}: ${rule.title}. ${rule.remediation}";

  report = {
    schemaVersion = 3;
    failureMode = cfg.failureMode;
    profile = builtins.removeAttrs selectedProfile ["catalog" "internal"];
    summary = {
      benchmarkRecommendations = builtins.length allRules;
      sourceAutomated = builtins.length (builtins.filter (rule: rule.assessment == "automated") allRules);
      sourceManual = builtins.length (builtins.filter (rule: rule.assessment == "manual") allRules);
      sourceUnspecified = builtins.length (builtins.filter (rule: rule.assessment == "unspecified") allRules);
      enabledRules = builtins.length enabledRules;
      disabled = countStatus "disabled";
      staticallyAssessed = countStatus "pass" + countStatus "fail";
      passed = countStatus "pass";
      violations = countStatus "fail";
      runtimeRequired = builtins.length (builtins.filter (rule: rule.enabled && rule.applicability == "runtime") allRules);
      notApplicable = countStatus "not-applicable";
      unsupported = builtins.length (builtins.filter (rule: rule.enabled && rule.applicability == "unsupported") allRules);
    };
    rules = publicRules;
  };
in {
  options.security.cisValidator = {
    enable = mkEnableOption "static CIS-aligned validation of the evaluated NixOS configuration";

    profile = mkOption {
      type = types.enum (builtins.attrNames profiles);
      default = "ubuntu-24.04-l1-server";
      description = "The versioned NixOS-native benchmark mapping profile to evaluate.";
    };

    failureMode = mkOption {
      type = types.enum [
        "report"
        "warn"
        "error"
      ];
      default = "warn";
      description = ''
        How detected static violations affect evaluation. `report` records
        violations only, `warn` also emits NixOS warnings, and `error` adds
        failing NixOS assertions. Unassessed and not-applicable recommendations
        never block evaluation.
      '';
    };

    defaultRuleEnable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether catalog recommendations are enabled unless overridden in rules.";
    };

    rules = mkOption {
      default = {};
      description = "Per-recommendation configuration keyed by CIS recommendation number.";
      type = types.attrsOf (types.submodule {
        options.enable = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to include this recommendation in validation.";
        };
      });
      example = {
        "1.1.1.1".enable = false;
      };
    };
  };

  config = mkIf cfg.enable {
    warnings =
      lib.optionals (cfg.failureMode == "warn")
      (map formatViolation violations);

    assertions =
      lib.optionals (cfg.failureMode == "error")
      (map (rule: {
          assertion = rule.passed;
          message = formatViolation rule;
        })
        violations);

    system.build.cisValidationReport =
      pkgs.writeText
      "nixos-cis-validation-report.json"
      (builtins.toJSON report);
  };
}
