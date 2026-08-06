{
  config,
  lib,
}: let
  valueAt = path: lib.attrByPath path null config;

  normalizeScalar = value:
    if builtins.isBool value
    then
      if value
      then 1
      else 0
    else value;

  mkStatic = {
    actual,
    expected,
    passed,
    option,
    applicability ? "native",
    phase ? "evaluation",
    target ? "nixos-option",
    description ? "The evaluated NixOS configuration must express the required security invariant.",
    remediation,
  }: {
    inherit applicability passed description remediation;
    validation = {inherit phase target;};
    evidence = {inherit actual expected option;};
  };

  optionEquals = {
    path,
    expected,
    applicability ? "native",
    description ? "The evaluated NixOS option must equal the expected value.",
    remediation ? "Set ${lib.concatStringsSep "." path} to the expected value.",
  }: let
    actual = valueAt path;
  in
    mkStatic {
      inherit actual expected applicability description remediation;
      option = lib.concatStringsSep "." path;
      passed = normalizeScalar actual == normalizeScalar expected;
    };

  optionSatisfies = {
    path,
    expected,
    predicate,
    applicability ? "native",
    description ? "The evaluated NixOS option must satisfy the expected security invariant.",
    remediation,
  }: let
    actual = valueAt path;
  in
    mkStatic {
      inherit actual expected applicability description remediation;
      option = lib.concatStringsSep "." path;
      passed = predicate actual;
    };

  sysctlEquals = name: expected:
    optionEquals {
      path = ["boot" "kernel" "sysctl" name];
      inherit expected;
      remediation = "Set boot.kernel.sysctl.\"${name}\" = ${builtins.toJSON expected}.";
    };

  kernelModuleBlocked = module: let
    configured = config.boot.blacklistedKernelModules;
    alternatives = [
      module
      (lib.replaceStrings ["-"] ["_"] module)
      (lib.replaceStrings ["_"] ["-"] module)
    ];
  in
    mkStatic {
      actual = configured;
      expected = "${module} is included in boot.blacklistedKernelModules";
      option = "boot.blacklistedKernelModules";
      applicability = "adapted";
      passed = lib.any (candidate: builtins.elem candidate configured) alternatives;
      description = "NixOS must declare the unused kernel module unavailable through its module blacklist.";
      remediation = "Add \"${module}\" to boot.blacklistedKernelModules.";
    };

  mountOption = mountPoint: option: let
    fileSystem = config.fileSystems.${mountPoint} or null;
    actual =
      if fileSystem == null
      then null
      else fileSystem.options;
  in
    mkStatic {
      inherit actual;
      expected = option;
      option = "fileSystems.\"${mountPoint}\".options";
      passed = fileSystem != null && builtins.elem option fileSystem.options;
      description = "The declared filesystem must include the ${option} mount option.";
      remediation = "Add \"${option}\" to fileSystems.\"${mountPoint}\".options.";
    };

  opensshSetting = name: expected:
    optionEquals {
      path = ["services" "openssh" "settings" name];
      inherit expected;
      remediation = "Set services.openssh.settings.${name} to ${builtins.toJSON expected}.";
    };

  optionsAllFalse = {
    paths,
    label,
    remediation,
  }: let
    values =
      map (path: {
        option = lib.concatStringsSep "." path;
        value = valueAt path;
      })
      paths;
  in
    mkStatic {
      actual = values;
      expected = "all listed service enable options are false";
      option = label;
      applicability = "adapted";
      passed = lib.all (item: item.value != true) values;
      description = "No NixOS service module associated with this unnecessary service may be enabled.";
      inherit remediation;
    };

  notApplicable = reason: {
    applicability = "not-applicable";
    inherit reason;
    validation = {
      phase = "none";
      target = "conditional-recommendation";
    };
  };
in {
  inherit
    kernelModuleBlocked
    mkStatic
    mountOption
    notApplicable
    opensshSetting
    optionEquals
    optionSatisfies
    optionsAllFalse
    sysctlEquals
    valueAt
    ;
}
