{
  config,
  helpers,
  ...
}: let
  inherit (helpers) mkStatic optionEquals optionSatisfies;
  appArmorEnabled = optionEquals {
    path = ["security" "apparmor" "enable"];
    expected = true;
    applicability = "adapted";
    description = "NixOS AppArmor provides the mandatory-access-control intent of the source SELinux recommendation.";
    remediation = "Set security.apparmor.enable = true and deploy the required AppArmor profiles.";
  };
  firewallEnabled = mkStatic {
    actual = config.networking.firewall.enable;
    expected = true;
    option = "networking.firewall.enable";
    passed = config.networking.firewall.enable;
    applicability = "adapted";
    description = "The NixOS firewall provides the packet-filtering intent of the source firewalld recommendation.";
    remediation = "Set networking.firewall.enable = true and review explicitly allowed ports and interfaces.";
  };
  timeDaemons = builtins.filter (value: value) [
    config.services.timesyncd.enable
    config.services.chrony.enable
    config.services.ntp.enable
    config.services.openntpd.enable
  ];
in {
  mappings = {
    "1.3.1.1" = appArmorEnabled;
    "1.3.1.2" = appArmorEnabled;
    "1.3.1.3" = appArmorEnabled;
    "1.3.1.4" = appArmorEnabled;
    "1.3.1.5" = appArmorEnabled;

    "2.3.1" = mkStatic {
      actual = builtins.length timeDaemons;
      expected = "exactly one enabled time synchronization daemon";
      option = "services.timesyncd/chrony/ntp/openntpd.enable";
      passed = builtins.length timeDaemons == 1;
      applicability = "adapted";
      description = "Exactly one supported NixOS time synchronization service must be enabled.";
      remediation = "Enable exactly one of services.timesyncd, services.chrony, services.ntp, or services.openntpd.";
    };
    "2.3.3" =
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

    "4.1.1" = firewallEnabled;
    "4.1.2" = firewallEnabled;
    "4.1.3" = firewallEnabled;
    "4.1.4" = firewallEnabled;

    "6.2.2.1.1" = optionEquals {
      path = ["services" "journald" "upload" "enable"];
      expected = true;
      applicability = "adapted";
      remediation = "Set services.journald.upload.enable = true when remote journal upload is required.";
    };
    "6.2.2.1.3" = optionEquals {
      path = ["services" "journald" "upload" "enable"];
      expected = true;
      applicability = "adapted";
      remediation = "Set services.journald.upload.enable = true.";
    };
    "6.2.2.2" = optionEquals {
      path = ["services" "journald" "forwardToSyslog"];
      expected = false;
      applicability = "adapted";
      remediation = "Set services.journald.forwardToSyslog = false for the journal-only logging path.";
    };
  };

  notApplicable =
    builtins.listToAttrs (map (id: {
        name = id;
        value = "NixOS does not use RPM/DNF repositories or RPM package-policy configuration.";
      }) [
        "1.2.1.1"
        "1.2.1.2"
        "1.2.1.3"
        "1.2.1.4"
        "1.2.1.5"
      ])
    // {
      "1.3.1.7" = "The SELinux MCS translation service is not part of the NixOS AppArmor adaptation.";
      "1.3.1.8" = "SETroubleshoot is not part of the NixOS AppArmor adaptation.";
    };

  runtime = {
    "1.3.1.6" = "Unconfined services require inspection of the active mandatory-access-control policy and running processes.";
    "2.2.4" = "Installed TFTP client programs must be inspected in the built system closure or running generation.";
    "4.1.5" = "Effective loopback firewall behavior requires inspection of the generated ruleset.";
    "4.1.6" = "Effective loopback source-address filtering requires inspection of the generated ruleset.";
    "4.1.7" = "Approved firewall services and ports require site policy and inspection of the generated ruleset.";
    "5.3.1.1" = "NixOS does not use authselect; the effective generated PAM stack requires build-artifact validation.";
    "6.1.3" = "Audit-tool integrity protection requires build-artifact and runtime filesystem validation.";
    "6.2.1.4" = "The effective logging pipeline requires build-artifact and runtime service validation.";
    "6.2.2.1.2" = "Remote journal authentication requires validating deployed credentials and connectivity.";
    "6.2.3.8" = "Effective rsyslog rotation requires generated-configuration and runtime validation.";
  };
}
