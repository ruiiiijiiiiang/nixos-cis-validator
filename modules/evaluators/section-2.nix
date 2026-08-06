{
  config,
  lib,
  helpers,
}: let
  inherit (helpers) mkStatic notApplicable optionEquals optionSatisfies optionsAllFalse valueAt;

  serviceDisabled = id: label: paths: {
    ${id} = optionsAllFalse {
      inherit paths;
      label = "NixOS service options for ${label}";
      remediation = "Disable the NixOS service modules providing ${label}, unless the service is explicitly required and excepted.";
    };
  };

  timesyncd = valueAt ["services" "timesyncd" "enable"] == true;
  chrony = valueAt ["services" "chrony" "enable"] == true;
  ntp = valueAt ["services" "ntp" "enable"] == true;
  openntpd = valueAt ["services" "openntpd" "enable"] == true;
  enabledTimeDaemons = builtins.filter (value: value) [timesyncd chrony ntp openntpd];
  timesyncdServers =
    if config.services.timesyncd.servers != null
    then config.services.timesyncd.servers
    else config.services.timesyncd.fallbackServers;
in
  lib.foldl' (left: right: left // right) {} [
    (serviceDisabled "2.1.1" "automounting" [["services" "autofs" "enable"]])
    (serviceDisabled "2.1.3" "mDNS/Avahi" [["services" "avahi" "enable"]])
    (serviceDisabled "2.1.5" "DHCP servers" [
      ["services" "kea" "dhcp4" "enable"]
      ["services" "kea" "dhcp6" "enable"]
    ])
    (serviceDisabled "2.1.6" "web servers" [
      ["services" "httpd" "enable"]
      ["services" "nginx" "enable"]
      ["services" "caddy" "enable"]
      ["services" "lighttpd" "enable"]
    ])
    (serviceDisabled "2.1.7" "DNS servers" [
      ["services" "bind" "enable"]
      ["services" "knot" "enable"]
      ["services" "unbound" "enable"]
      ["services" "pdns-recursor" "enable"]
    ])
    (serviceDisabled "2.1.8" "FTP servers" [
      ["services" "vsftpd" "enable"]
      ["services" "proftpd" "enable"]
    ])
    (serviceDisabled "2.1.9" "dnsmasq" [["services" "dnsmasq" "enable"]])
    (serviceDisabled "2.1.10" "LDAP servers" [["services" "openldap" "enable"]])
    (serviceDisabled "2.1.11" "mail access servers" [
      ["services" "dovecot2" "enable"]
      ["services" "cyrus-imapd" "enable"]
    ])
    (serviceDisabled "2.1.12" "network filesystems" [
      ["services" "nfs" "server" "enable"]
      ["services" "glusterfs" "enable"]
    ])
    (serviceDisabled "2.1.13" "NIS servers" [["services" "ypserv" "enable"]])
    (serviceDisabled "2.1.14" "print servers" [["services" "printing" "enable"]])
    (serviceDisabled "2.1.15" "rpcbind" [["services" "rpcbind" "enable"]])
    (serviceDisabled "2.1.16" "rsync daemon" [["services" "rsyncd" "enable"]])
    (serviceDisabled "2.1.17" "Samba" [
      ["services" "samba" "enable"]
      ["services" "samba4" "enable"]
    ])
    (serviceDisabled "2.1.18" "SNMP" [["services" "snmpd" "enable"]])
    (serviceDisabled "2.1.19" "telnet servers" [["services" "telnetd" "enable"]])
    (serviceDisabled "2.1.20" "TFTP servers" [["services" "atftpd" "enable"]])
    (serviceDisabled "2.1.21" "web proxy servers" [
      ["services" "squid" "enable"]
      ["services" "tinyproxy" "enable"]
    ])
    (serviceDisabled "2.1.22" "xinetd" [["services" "xinetd" "enable"]])

    {
      "2.1.2" = optionsAllFalse {
        paths = [
          ["services" "postfix" "enable"]
          ["services" "exim" "enable"]
          ["services" "opensmtpd" "enable"]
        ];
        label = "mail transfer agent service options";
        remediation = "Disable mail transfer agents or separately verify that the selected MTA listens only on loopback interfaces.";
      };

      "2.3.1.1" = mkStatic {
        actual = {
          inherit timesyncd chrony ntp openntpd;
        };
        expected = "exactly one enabled time synchronization daemon";
        option = "services.timesyncd/chrony/ntp/openntpd.enable";
        passed = builtins.length enabledTimeDaemons == 1;
        applicability = "adapted";
        description = "Exactly one supported NixOS time synchronization service must be enabled.";
        remediation = "Enable exactly one of services.timesyncd, services.chrony, services.ntp, or services.openntpd.";
      };

      "2.3.2.1" =
        if !timesyncd
        then notApplicable "systemd-timesyncd is not the selected time synchronization daemon."
        else
          optionSatisfies {
            path = ["services" "timesyncd" "servers"];
            expected = "a non-empty authorized server list, directly or through fallbackServers";
            predicate = _: timesyncdServers != null && timesyncdServers != [];
            remediation = "Set services.timesyncd.servers or services.timesyncd.fallbackServers to approved time sources.";
          };
      "2.3.2.2" =
        if !timesyncd
        then notApplicable "systemd-timesyncd is not the selected time synchronization daemon."
        else
          optionEquals {
            path = ["services" "timesyncd" "enable"];
            expected = true;
            remediation = "Set services.timesyncd.enable = true.";
          };
      "2.3.3.1" =
        if !chrony
        then notApplicable "chrony is not the selected time synchronization daemon."
        else
          optionSatisfies {
            path = ["services" "chrony" "servers"];
            expected = "a non-empty authorized server list";
            predicate = actual: builtins.isList actual && actual != [];
            remediation = "Set services.chrony.servers to approved time sources.";
          };
      "2.3.3.2" =
        if !chrony
        then notApplicable "chrony is not the selected time synchronization daemon."
        else {
          applicability = "adapted";
          passed = true;
          description = "The NixOS chrony module runs chronyd under its dedicated service identity.";
          remediation = "Use the NixOS services.chrony module rather than a custom systemd unit.";
          validation = {
            phase = "evaluation";
            target = "nixos-module-invariant";
          };
          evidence = {
            option = "services.chrony.enable";
            actual = true;
            expected = true;
          };
        };
      "2.3.3.3" =
        if !chrony
        then notApplicable "chrony is not the selected time synchronization daemon."
        else
          optionEquals {
            path = ["services" "chrony" "enable"];
            expected = true;
            remediation = "Set services.chrony.enable = true.";
          };

      "2.4.1.1" = optionEquals {
        path = ["services" "cron" "enable"];
        expected = true;
        remediation = "Set services.cron.enable = true when the benchmark's cron scheduling model is required.";
        applicability = "adapted";
      };
    }
  ]
