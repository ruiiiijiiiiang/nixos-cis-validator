{
  config,
  helpers,
  ...
}: let
  inherit (helpers) optionEquals optionSatisfies optionsAllFalse;
in {
  mappings = {
    "2.1.16" = optionsAllFalse {
      paths = [["services" "telnetd" "enable"]];
      label = "NixOS telnet server service option";
      remediation = "Disable services.telnetd.enable unless the service is explicitly required and excepted.";
    };
    "2.3.3.1" =
      if config.services.chrony.enable
      then
        optionSatisfies {
          path = ["services" "chrony" "servers"];
          expected = "a non-empty authorized server list";
          predicate = actual: builtins.isList actual && actual != [];
          remediation = "Set services.chrony.servers to approved time sources.";
        }
      else helpers.notApplicable "chrony is not the selected time synchronization daemon.";
    "6.1.1.1.4" = optionEquals {
      path = ["services" "journald" "settings" "Journal" "ForwardToSyslog"];
      expected = false;
      applicability = "adapted";
      remediation = "Set services.journald.settings.Journal.ForwardToSyslog = false for the journal-only logging path.";
    };
    "6.1.1.2.1" = optionEquals {
      path = ["services" "journald" "upload" "enable"];
      expected = true;
      applicability = "adapted";
      remediation = "Set services.journald.upload.enable = true when remote journal upload is required.";
    };
    "6.1.1.2.3" = optionEquals {
      path = ["services" "journald" "upload" "enable"];
      expected = true;
      applicability = "adapted";
      remediation = "Set services.journald.upload.enable = true.";
    };
  };

  notApplicable = builtins.listToAttrs (map (id: {
      name = id;
      value = "NixOS does not use APT repositories or APT package-policy configuration.";
    }) [
      "1.2.1.1"
      "1.2.1.2"
      "1.2.1.3"
      "1.2.1.4"
      "1.2.1.5"
      "1.2.1.6"
      "1.2.1.7"
      "1.2.1.8"
      "1.2.1.9"
    ]);

  runtime = {
    "6.1.1.2.2" = "Remote journal authentication requires validating deployed credentials and connectivity.";
  };
}
