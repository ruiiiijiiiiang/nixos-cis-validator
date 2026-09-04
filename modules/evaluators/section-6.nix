{
  config,
  lib,
  helpers,
}: let
  inherit (helpers) mkStatic optionEquals optionSatisfies;
  rsyslogConfig = config.services.rsyslogd.defaultConfig + "\n" + config.services.rsyslogd.extraConfig;
in {
  "6.1.1.1.1" = mkStatic {
    actual = true;
    expected = true;
    option = "NixOS systemd-journald platform invariant";
    passed = true;
    applicability = "adapted";
    description = "NixOS includes and activates systemd-journald as a core system service.";
    remediation = "Use the standard NixOS systemd implementation and do not mask systemd-journald.";
  };
  "6.1.1.1.2" = optionEquals {
    path = ["services" "journald" "remote" "enable"];
    expected = false;
    remediation = "Set services.journald.remote.enable = false unless this host is an approved journal receiver.";
    applicability = "adapted";
  };
  "6.1.1.1.3" = optionEquals {
    path = ["services" "journald" "settings" "Journal" "ForwardToSyslog"];
    expected = true;
    remediation = "Set services.journald.settings.Journal.ForwardToSyslog = true when using the benchmark's rsyslog logging path.";
    applicability = "adapted";
  };
  "6.1.1.1.6" = optionSatisfies {
    path = ["services" "journald" "settings" "Journal" "Storage"];
    expected = "persistent";
    predicate = actual: actual == "persistent";
    remediation = "Set services.journald.settings.Journal.Storage = \"persistent\".";
    applicability = "adapted";
  };
  "6.1.1.1.7" = optionSatisfies {
    path = ["services" "journald" "settings" "Journal" "Compress"];
    expected = "Compress=yes, or the secure systemd default";
    predicate = actual:
      actual
      == null
      || actual == true
      || actual == 1
      || (builtins.isString actual && lib.elem (lib.toLower actual) ["yes" "true" "on" "1"]);
    applicability = "adapted";
    description = "The evaluated journald configuration must not disable journal compression.";
    remediation = "Remove an explicit false value or set services.journald.settings.Journal.Compress = true.";
  };

  "6.1.2.1" = optionEquals {
    path = ["services" "rsyslogd" "enable"];
    expected = true;
    remediation = "Set services.rsyslogd.enable = true when using the benchmark's rsyslog path.";
    applicability = "adapted";
  };
  "6.1.2.2" = optionEquals {
    path = ["services" "rsyslogd" "enable"];
    expected = true;
    remediation = "Set services.rsyslogd.enable = true.";
    applicability = "adapted";
  };
  "6.1.2.3" = mkStatic {
    actual = rsyslogConfig;
    expected = "an explicit $FileCreateMode of 0640 or stricter";
    option = "services.rsyslogd.defaultConfig/extraConfig";
    passed = lib.hasInfix "$FileCreateMode 0640" rsyslogConfig || lib.hasInfix "$FileCreateMode 0600" rsyslogConfig;
    description = "The generated rsyslog policy must explicitly restrict newly created log files.";
    remediation = "Add $FileCreateMode 0640 or a stricter value to services.rsyslogd.extraConfig.";
  };
  "6.1.2.6" = mkStatic {
    actual = config.services.rsyslogd.extraConfig;
    expected = "no imtcp/imudp input modules or input() listeners";
    option = "services.rsyslogd.extraConfig";
    passed =
      !lib.hasInfix "imtcp" config.services.rsyslogd.extraConfig
      && !lib.hasInfix "imudp" config.services.rsyslogd.extraConfig
      && !lib.hasInfix "input(" config.services.rsyslogd.extraConfig;
    description = "The host rsyslog configuration must not declare a network log receiver.";
    remediation = "Remove network input modules and listeners from services.rsyslogd.extraConfig unless explicitly excepted.";
  };
}
