{
  config,
  lib,
  helpers,
}: let
  inherit (helpers) kernelModuleBlocked mkStatic mountOption optionEquals optionSatisfies sysctlEquals;

  tmpIsSeparate = config.boot.tmp.useTmpfs || builtins.hasAttr "/tmp" config.fileSystems;
  etcTextConfigured = name: let
    entry = config.environment.etc.${name} or null;
  in
    entry != null && ((entry.text or null) != null || (entry.source or null) != null);
in {
  "1.1.1.1" = kernelModuleBlocked "cramfs";
  "1.1.1.2" = kernelModuleBlocked "freevxfs";
  "1.1.1.3" = kernelModuleBlocked "hfs";
  "1.1.1.4" = kernelModuleBlocked "hfsplus";
  "1.1.1.5" = kernelModuleBlocked "jffs2";
  "1.1.1.9" = kernelModuleBlocked "firewire-core";
  "1.1.1.10" = kernelModuleBlocked "usb-storage";

  "1.1.2.1.1" = mkStatic {
    actual = tmpIsSeparate;
    expected = true;
    option = "boot.tmp.useTmpfs or fileSystems.\"/tmp\"";
    passed = tmpIsSeparate;
    applicability = "adapted";
    description = "NixOS must declare /tmp as tmpfs or as a separate filesystem.";
    remediation = "Set boot.tmp.useTmpfs = true or declare fileSystems.\"/tmp\".";
  };
  "1.1.2.1.2" = mountOption "/tmp" "nodev";
  "1.1.2.1.3" = mountOption "/tmp" "nosuid";
  "1.1.2.1.4" = mountOption "/tmp" "noexec";
  "1.1.2.3.2" = mountOption "/home" "nodev";
  "1.1.2.3.3" = mountOption "/home" "nosuid";
  "1.1.2.4.2" = mountOption "/var" "nodev";
  "1.1.2.4.3" = mountOption "/var" "nosuid";
  "1.1.2.5.2" = mountOption "/var/tmp" "nodev";
  "1.1.2.5.3" = mountOption "/var/tmp" "nosuid";
  "1.1.2.5.4" = mountOption "/var/tmp" "noexec";
  "1.1.2.6.2" = mountOption "/var/log" "nodev";
  "1.1.2.6.3" = mountOption "/var/log" "nosuid";
  "1.1.2.6.4" = mountOption "/var/log" "noexec";
  "1.1.2.7.2" = mountOption "/var/log/audit" "nodev";
  "1.1.2.7.3" = mountOption "/var/log/audit" "nosuid";
  "1.1.2.7.4" = mountOption "/var/log/audit" "noexec";

  "1.3.1.1" = optionEquals {
    path = ["security" "apparmor" "enable"];
    expected = true;
    applicability = "adapted";
    remediation = "Set security.apparmor.enable = true.";
  };
  "1.3.1.2" = optionEquals {
    path = ["security" "apparmor" "enable"];
    expected = true;
    remediation = "Set security.apparmor.enable = true.";
  };
  "1.3.1.4" = sysctlEquals "kernel.apparmor_restrict_unprivileged_unconfined" 1;

  "1.5.1" = sysctlEquals "fs.protected_hardlinks" 1;
  "1.5.3" = optionSatisfies {
    path = ["boot" "kernel" "sysctl" "kernel.yama.ptrace_scope"];
    expected = "an integer greater than or equal to 1";
    predicate = actual: builtins.isInt actual && actual >= 1;
    remediation = "Set boot.kernel.sysctl.\"kernel.yama.ptrace_scope\" = 1 or a stricter value.";
  };
  "1.5.4" = sysctlEquals "fs.suid_dumpable" 0;
  "1.5.5" = sysctlEquals "kernel.dmesg_restrict" 1;
  "1.5.8" = optionSatisfies {
    path = ["boot" "kernel" "sysctl" "kernel.kptr_restrict"];
    expected = "an integer greater than or equal to 1";
    predicate = actual: builtins.isInt actual && actual >= 1;
    remediation = "Set boot.kernel.sysctl.\"kernel.kptr_restrict\" = 1 or a stricter value.";
  };
  "1.5.9" = sysctlEquals "kernel.randomize_va_space" 2;
  "1.5.11" = optionEquals {
    path = ["systemd" "coredump" "settings" "Coredump" "ProcessSizeMax"];
    expected = 0;
    remediation = "Set systemd.coredump.settings.Coredump.ProcessSizeMax = 0.";
  };
  "1.5.12" = optionSatisfies {
    path = ["systemd" "coredump" "settings" "Coredump" "Storage"];
    expected = "none";
    predicate = actual: actual == "none" || actual == "None";
    remediation = "Set systemd.coredump.settings.Coredump.Storage = \"none\".";
  };

  "1.6.1" = mkStatic {
    actual = etcTextConfigured "motd";
    expected = true;
    option = "environment.etc.\"motd\"";
    passed = etcTextConfigured "motd";
    applicability = "adapted";
    description = "A declarative message-of-the-day file must be configured.";
    remediation = "Configure environment.etc.\"motd\".text with an approved legal notice.";
  };
  "1.6.2" = mkStatic {
    actual = etcTextConfigured "issue";
    expected = true;
    option = "environment.etc.\"issue\"";
    passed = etcTextConfigured "issue";
    applicability = "adapted";
    description = "A declarative local login warning banner must be configured.";
    remediation = "Configure environment.etc.\"issue\".text with an approved legal notice.";
  };
  "1.6.3" = mkStatic {
    actual = etcTextConfigured "issue.net";
    expected = true;
    option = "environment.etc.\"issue.net\"";
    passed = etcTextConfigured "issue.net";
    applicability = "adapted";
    description = "A declarative remote login warning banner must be configured.";
    remediation = "Configure environment.etc.\"issue.net\".text with an approved legal notice.";
  };
  "1.6.4" = optionEquals {
    path = ["security" "pam" "services" "login" "showMotd"];
    expected = true;
    applicability = "adapted";
    remediation = "Set security.pam.services.login.showMotd = true.";
  };
}
