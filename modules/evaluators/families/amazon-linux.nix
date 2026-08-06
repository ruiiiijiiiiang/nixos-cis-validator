{
  config,
  lib,
  helpers,
}: let
  inherit (helpers) kernelModuleBlocked mkStatic optionEquals sysctlEquals;

  appArmorEnabled = optionEquals {
    path = ["security" "apparmor" "enable"];
    expected = true;
    applicability = "adapted";
    description = "NixOS AppArmor provides the mandatory-access-control intent of the source SELinux recommendation.";
    remediation = "Set security.apparmor.enable = true and deploy the required AppArmor profiles.";
  };

  timeDaemons = builtins.filter (value: value) [
    config.services.timesyncd.enable
    config.services.chrony.enable
    config.services.ntp.enable
    config.services.openntpd.enable
  ];

  etcTextConfigured = name: let
    entry = config.environment.etc.${name} or null;
  in
    entry != null && ((entry.text or null) != null || (entry.source or null) != null);

  banner = name: description: remediation:
    mkStatic {
      actual = etcTextConfigured name;
      expected = true;
      option = "environment.etc.\"${name}\"";
      passed = etcTextConfigured name;
      applicability = "adapted";
      inherit description remediation;
    };

  coreLimitConfigured =
    lib.any (
      limit:
        (limit.domain or null)
        == "*"
        && builtins.elem (limit.type or null) ["-" "hard"]
        && (limit.item or null) == "core"
        && toString (limit.value or "") == "0"
    )
    config.security.pam.loginLimits;
in {
  mappings = {
    "1.1.1.4" = kernelModuleBlocked "overlay";
    "1.1.1.5" = kernelModuleBlocked "squashfs";
    "1.1.1.6" = kernelModuleBlocked "udf";
    "1.1.2.2.1" = mkStatic {
      actual = true;
      expected = true;
      option = "NixOS systemd /dev/shm mount invariant";
      passed = true;
      applicability = "adapted";
      description = "The standard NixOS systemd configuration mounts /dev/shm as tmpfs.";
      remediation = "Use the standard NixOS systemd /dev/shm mount and do not replace it with a persistent filesystem.";
    };

    "1.4.1.1" = appArmorEnabled;
    "1.4.1.2" = appArmorEnabled;
    "1.4.1.3" = appArmorEnabled;
    "1.4.1.4" = appArmorEnabled;

    "1.5.1" = mkStatic {
      actual = config.security.pam.loginLimits;
      expected = "a wildcard hard or combined core limit of 0";
      option = "security.pam.loginLimits";
      passed = coreLimitConfigured;
      applicability = "adapted";
      description = "The generated PAM limits policy must disable core files for users.";
      remediation = ''
        Add { domain = "*"; type = "hard"; item = "core"; value = "0"; }
        to security.pam.loginLimits.
      '';
    };
    "1.5.3" = sysctlEquals "fs.protected_symlinks" 1;

    "1.6.1" = banner "motd" "A declarative message-of-the-day file must be configured." "Configure environment.etc.\"motd\".text with an approved legal notice.";
    "1.6.2" = banner "issue" "A declarative local login warning banner must be configured." "Configure environment.etc.\"issue\".text with an approved legal notice.";
    "1.6.3" = banner "issue.net" "A declarative remote login warning banner must be configured." "Configure environment.etc.\"issue.net\".text with an approved legal notice.";

    "2.1.1" = mkStatic {
      actual = builtins.length timeDaemons;
      expected = "exactly one enabled time synchronization daemon";
      option = "services.timesyncd/chrony/ntp/openntpd.enable";
      passed = builtins.length timeDaemons == 1;
      applicability = "adapted";
      description = "Exactly one supported NixOS time synchronization service must be enabled.";
      remediation = "Enable exactly one of services.timesyncd, services.chrony, services.ntp, or services.openntpd.";
    };
    "2.1.3" =
      if config.services.chrony.enable
      then
        mkStatic {
          actual = true;
          expected = true;
          option = "NixOS chrony service identity invariant";
          passed = true;
          applicability = "adapted";
          description = "The NixOS chrony module runs chronyd under its dedicated service identity.";
          remediation = "Use services.chrony rather than a custom chronyd systemd unit.";
        }
      else helpers.notApplicable "chrony is not the selected time synchronization daemon.";

    "3.3.1.1" = sysctlEquals "net.ipv4.ip_forward" 0;

    "5.5.1.2" = mkStatic {
      actual = config.security.loginDefs.settings.PASS_MIN_DAYS or null;
      expected = "an integer greater than or equal to 1";
      option = "security.loginDefs.settings.PASS_MIN_DAYS";
      passed =
        builtins.isInt (config.security.loginDefs.settings.PASS_MIN_DAYS or null)
        && config.security.loginDefs.settings.PASS_MIN_DAYS >= 1;
      remediation = "Set security.loginDefs.settings.PASS_MIN_DAYS to 1 or a stricter site-approved value.";
    };

    "6.1.1.5" = optionEquals {
      path = ["services" "journald" "forwardToSyslog"];
      expected = true;
      applicability = "adapted";
      remediation = "Set services.journald.forwardToSyslog = true for the benchmark's rsyslog logging path.";
    };
  };

  notApplicable = {
    "1.2.1" = "NixOS does not use RPM GPG-key configuration.";
    "1.2.2" = "NixOS does not use RPM/DNF gpgcheck configuration.";
    "1.2.4" = "NixOS does not use RPM/DNF repositories.";
    "1.4.1.7" = "The SELinux MCS translation service is not part of the NixOS AppArmor adaptation.";
  };

  runtime = {
    "1.3.1" = "Single-user boot authentication depends on the selected bootloader and deployed recovery environment.";
    "2.3.5" = "Installed TFTP client programs must be inspected in the built system closure or running generation.";
    "5.4.1.2" = "The presence and version of libpwquality requires inspection of the generated PAM closure.";
    "6.3.3" = "Audit-tool integrity protection requires build-artifact and runtime filesystem validation.";
  };
}
