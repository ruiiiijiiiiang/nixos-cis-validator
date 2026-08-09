{
  config,
  lib,
  helpers,
}: let
  inherit (helpers) mkStatic notApplicable opensshSetting optionEquals optionSatisfies valueAt;

  sshEnabled = config.services.openssh.enable;
  ssh = config.services.openssh.settings;
  sshRule = result:
    if sshEnabled
    then result
    else notApplicable "The NixOS OpenSSH server is disabled.";
  nonEmpty = value: value != null && value != [] && value != "";
  positiveInt = value: builtins.isInt value && value > 0;
  intAtMost = maximum: value: builtins.isInt value && value > 0 && value <= maximum;

  sshAccessConfigured = lib.any nonEmpty [
    ssh.AllowUsers
    ssh.AllowGroups
    ssh.DenyUsers
    ssh.DenyGroups
  ];

  approvedAlgorithms = option: weak:
    optionSatisfies {
      path = ["services" "openssh" "settings" option];
      expected = "a non-empty list without benchmark-prohibited algorithms";
      predicate = actual:
        builtins.isList actual
        && actual != []
        && lib.all (algorithm: !builtins.elem algorithm weak) actual;
      remediation = "Configure services.openssh.settings.${option} with an approved algorithm list.";
    };

  sudoEnabled = config.security.sudo.enable || (valueAt ["security" "sudo-rs" "enable"] == true);
  sudoConfig = config.security.sudo.configFile;
  pamServices = lib.attrValues config.security.pam.services;

  loginDefs = config.security.loginDefs.settings;
  integerSetting = name: loginDefs.${name} or null;

  uidZeroUsers = lib.attrNames (lib.filterAttrs (_: user: (user.uid or null) == 0) config.users.users);
  gidZeroGroups = lib.attrNames (lib.filterAttrs (_: group: (group.gid or null) == 0) config.users.groups);
in {
  "5.1.4" = sshRule (mkStatic {
    actual = {
      inherit (ssh) AllowUsers AllowGroups DenyUsers DenyGroups;
    };
    expected = "at least one non-empty SSH allow or deny list";
    option = "services.openssh.settings.AllowUsers/AllowGroups/DenyUsers/DenyGroups";
    passed = sshAccessConfigured;
    applicability = "adapted";
    description = "The SSH service must declaratively restrict access using at least one user or group allow/deny list.";
    remediation = "Configure one of services.openssh.settings.AllowUsers, AllowGroups, DenyUsers, or DenyGroups according to site policy.";
  });
  "5.1.5" = sshRule (optionSatisfies {
    path = ["services" "openssh" "settings" "Banner"];
    expected = "a configured banner path";
    predicate = nonEmpty;
    remediation = "Set services.openssh.settings.Banner to the declaratively managed warning-banner path.";
  });
  "5.1.6" = sshRule (approvedAlgorithms "Ciphers" [
    "3des-cbc"
    "aes128-cbc"
    "aes192-cbc"
    "aes256-cbc"
  ]);
  "5.1.7" = sshRule (mkStatic {
    actual = {
      ClientAliveInterval = ssh.ClientAliveInterval or null;
      ClientAliveCountMax = ssh.ClientAliveCountMax or null;
    };
    expected = "ClientAliveInterval and ClientAliveCountMax greater than zero";
    option = "services.openssh.settings.ClientAliveInterval/ClientAliveCountMax";
    passed = positiveInt (ssh.ClientAliveInterval or null) && positiveInt (ssh.ClientAliveCountMax or null);
    description = "Both SSH client-alive controls must be explicitly configured to positive values.";
    remediation = "Set services.openssh.settings.ClientAliveInterval and ClientAliveCountMax to positive site-approved values.";
  });
  "5.1.10" = sshRule (opensshSetting "HostbasedAuthentication" false);
  "5.1.11" = sshRule (opensshSetting "IgnoreRhosts" true);
  "5.1.12" = sshRule (approvedAlgorithms "KexAlgorithms" [
    "diffie-hellman-group1-sha1"
    "diffie-hellman-group14-sha1"
    "diffie-hellman-group-exchange-sha1"
  ]);
  "5.1.13" = sshRule (optionSatisfies {
    path = ["services" "openssh" "settings" "LoginGraceTime"];
    expected = "an integer from 1 through 60 seconds";
    predicate = intAtMost 60;
    remediation = "Set services.openssh.settings.LoginGraceTime to a value from 1 through 60.";
  });
  "5.1.14" = sshRule (optionSatisfies {
    path = ["services" "openssh" "settings" "LogLevel"];
    expected = "INFO or VERBOSE";
    predicate = actual: builtins.elem actual ["INFO" "VERBOSE"];
    remediation = "Set services.openssh.settings.LogLevel to \"INFO\" or \"VERBOSE\".";
  });
  "5.1.15" = sshRule (approvedAlgorithms "Macs" [
    "hmac-md5"
    "hmac-md5-96"
    "hmac-sha1"
    "hmac-sha1-96"
    "umac-64@openssh.com"
    "umac-64-etm@openssh.com"
  ]);
  "5.1.16" = sshRule (optionSatisfies {
    path = ["services" "openssh" "settings" "MaxAuthTries"];
    expected = "an integer from 1 through 4";
    predicate = intAtMost 4;
    remediation = "Set services.openssh.settings.MaxAuthTries to 4 or less.";
  });
  "5.1.17" = sshRule (optionSatisfies {
    path = ["services" "openssh" "settings" "MaxStartups"];
    expected = "10:30:60 or a site-approved stricter value";
    predicate = actual: actual == "10:30:60";
    remediation = "Set services.openssh.settings.MaxStartups = \"10:30:60\" or disable this rule when a reviewed stricter value is used.";
  });
  "5.1.18" = sshRule (optionSatisfies {
    path = ["services" "openssh" "settings" "MaxSessions"];
    expected = "an integer from 1 through 10";
    predicate = intAtMost 10;
    remediation = "Set services.openssh.settings.MaxSessions to 10 or less.";
  });
  "5.1.19" = sshRule (opensshSetting "PermitEmptyPasswords" false);
  "5.1.20" = sshRule (opensshSetting "PermitRootLogin" "no");
  "5.1.21" = sshRule (opensshSetting "PermitUserEnvironment" false);
  "5.1.22" = sshRule (opensshSetting "UsePAM" true);
  "5.1.23" = sshRule (optionSatisfies {
    path = ["services" "openssh" "settings" "KexAlgorithms"];
    expected = "at least one ML-KEM or sntrup post-quantum hybrid key exchange";
    predicate = actual:
      builtins.isList actual
      && lib.any (algorithm: lib.hasPrefix "mlkem" algorithm || lib.hasPrefix "sntrup" algorithm) actual;
    remediation = "Include a supported ML-KEM or sntrup hybrid in services.openssh.settings.KexAlgorithms.";
  });

  "5.2.1" = mkStatic {
    actual = sudoEnabled;
    expected = true;
    option = "security.sudo.enable or security.sudo-rs.enable";
    passed = sudoEnabled;
    applicability = "adapted";
    description = "A supported declarative privilege-escalation implementation must be enabled.";
    remediation = "Enable security.sudo or security.sudo-rs.";
  };
  "5.2.2" = mkStatic {
    actual = lib.hasInfix "use_pty" sudoConfig;
    expected = true;
    option = "security.sudo.configFile";
    passed = config.security.sudo.enable && lib.hasInfix "use_pty" sudoConfig;
    description = "The generated sudoers policy must contain the use_pty default.";
    remediation = "Add Defaults use_pty through security.sudo.extraConfig.";
  };
  "5.2.3" = mkStatic {
    actual = lib.hasInfix "logfile=" sudoConfig;
    expected = true;
    option = "security.sudo.configFile";
    passed = config.security.sudo.enable && lib.hasInfix "logfile=" sudoConfig;
    description = "The generated sudoers policy must configure a dedicated log file.";
    remediation = "Add a site-approved Defaults logfile= setting through security.sudo.extraConfig.";
  };
  "5.2.5" = optionEquals {
    path = ["security" "sudo" "wheelNeedsPassword"];
    expected = true;
    remediation = "Set security.sudo.wheelNeedsPassword = true and review extra sudo rules for NOPASSWD.";
  };
  "5.2.6" = mkStatic {
    actual = lib.hasInfix "timestamp_timeout=" sudoConfig;
    expected = "an explicit site-approved timestamp_timeout of 15 minutes or less";
    option = "security.sudo.configFile";
    passed = config.security.sudo.enable && lib.hasInfix "timestamp_timeout=" sudoConfig;
    description = "The generated sudoers policy must explicitly bound credential caching.";
    remediation = "Add Defaults timestamp_timeout=15 or a stricter value through security.sudo.extraConfig.";
  };
  "5.2.7" = optionEquals {
    path = ["security" "pam" "services" "su" "requireWheel"];
    expected = true;
    remediation = "Set security.pam.services.su.requireWheel = true.";
    applicability = "adapted";
  };

  "5.3.1.1" = optionEquals {
    path = ["security" "pam" "enable"];
    expected = true;
    remediation = "Keep security.pam.enable = true.";
    applicability = "adapted";
  };
  "5.3.2.1" = mkStatic {
    actual = config.security.pam.enable;
    expected = true;
    option = "security.pam.enable";
    passed = config.security.pam.enable;
    applicability = "adapted";
    description = "The NixOS PAM module includes pam_unix in its generated default service stacks.";
    remediation = "Keep security.pam.enable = true and use the NixOS PAM service generator.";
  };
  "5.3.2.2" = mkStatic {
    actual = map (service: service.logFailures) pamServices;
    expected = "pam_faillock enabled for applicable authentication services";
    option = "security.pam.services.<name>.logFailures";
    passed = lib.any (service: service.logFailures) pamServices;
    applicability = "adapted";
    description = "At least one applicable PAM authentication service must enable the NixOS pam_faillock integration.";
    remediation = "Enable security.pam.services.<service>.logFailures for every password-authenticating entry point.";
  };
  "5.3.3.4.1" = mkStatic {
    actual = map (service: service.allowNullPassword) pamServices;
    expected = "false for every generated PAM service";
    option = "security.pam.services.<name>.allowNullPassword";
    passed = lib.all (service: !service.allowNullPassword) pamServices;
    applicability = "adapted";
    description = "No generated PAM service may enable null passwords.";
    remediation = "Set allowNullPassword = false for all security.pam.services entries.";
  };
  "5.3.3.4.3" = optionSatisfies {
    path = ["security" "loginDefs" "settings" "ENCRYPT_METHOD"];
    expected = "YESCRYPT or SHA512";
    predicate = actual: builtins.elem actual ["YESCRYPT" "SHA512"];
    remediation = "Set security.loginDefs.settings.ENCRYPT_METHOD = \"YESCRYPT\".";
    applicability = "adapted";
  };
  "5.3.3.4.4" = mkStatic {
    actual = config.security.pam.enable;
    expected = true;
    option = "security.pam.enable";
    passed = config.security.pam.enable;
    applicability = "adapted";
    description = "The generated NixOS PAM password stack passes authentication tokens between required modules.";
    remediation = "Use the NixOS PAM generator and avoid replacing its pam_unix password stack with unmanaged text.";
  };

  "5.4.1.1" = mkStatic {
    actual = integerSetting "PASS_MAX_DAYS";
    expected = "an integer from 1 through 365";
    option = "security.loginDefs.settings.PASS_MAX_DAYS";
    passed = intAtMost 365 (integerSetting "PASS_MAX_DAYS");
    applicability = "adapted";
    description = "The default maximum password age must be explicitly bounded.";
    remediation = "Set security.loginDefs.settings.PASS_MAX_DAYS = 365 or a stricter positive value.";
  };
  "5.4.1.3" = optionSatisfies {
    path = ["security" "loginDefs" "settings" "PASS_WARN_AGE"];
    expected = "an integer greater than or equal to 7";
    predicate = actual: builtins.isInt actual && actual >= 7;
    remediation = "Set security.loginDefs.settings.PASS_WARN_AGE = 7 or a larger site-approved value.";
    applicability = "adapted";
  };
  "5.4.1.4" = optionSatisfies {
    path = ["security" "loginDefs" "settings" "ENCRYPT_METHOD"];
    expected = "YESCRYPT or SHA512";
    predicate = actual: builtins.elem actual ["YESCRYPT" "SHA512"];
    remediation = "Set security.loginDefs.settings.ENCRYPT_METHOD = \"YESCRYPT\".";
    applicability = "adapted";
  };
  "5.4.1.5" = optionSatisfies {
    path = ["security" "loginDefs" "settings" "INACTIVE"];
    expected = "an integer from 0 through 45";
    predicate = actual: builtins.isInt actual && actual >= 0 && actual <= 45;
    remediation = "Set security.loginDefs.settings.INACTIVE = 45 or a stricter non-negative value.";
    applicability = "adapted";
  };
  "5.4.2.1" = mkStatic {
    actual = uidZeroUsers;
    expected = ["root"];
    option = "users.users.<name>.uid";
    passed = uidZeroUsers == ["root"];
    applicability = "adapted";
    description = "Only the declarative root user may have UID 0.";
    remediation = "Remove UID 0 from every users.users entry except root and reconcile mutable runtime accounts.";
  };
  "5.4.2.3" = mkStatic {
    actual = gidZeroGroups;
    expected = ["root"];
    option = "users.groups.<name>.gid";
    passed = gidZeroGroups == ["root"];
    applicability = "adapted";
    description = "Only the declarative root group may have GID 0.";
    remediation = "Remove GID 0 from every users.groups entry except root and reconcile mutable runtime groups.";
  };
  "5.4.3.2" = optionSatisfies {
    path = ["environment" "interactiveShellInit"];
    expected = "a readonly exported TMOUT no greater than 900 seconds";
    predicate = actual: builtins.isString actual && lib.hasInfix "TMOUT=" actual && lib.hasInfix "readonly" actual;
    remediation = "Declare a readonly exported TMOUT of 900 seconds or less in environment.interactiveShellInit.";
    applicability = "adapted";
  };
  "5.4.3.3" = optionSatisfies {
    path = ["security" "loginDefs" "settings" "UMASK"];
    expected = "027 or a stricter mask";
    predicate = actual: builtins.elem (toString actual) ["027" "077" "0027" "0077"];
    remediation = "Set security.loginDefs.settings.UMASK = \"027\" or a stricter site-approved mask.";
    applicability = "adapted";
  };
}
