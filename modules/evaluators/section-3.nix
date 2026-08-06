{
  config,
  lib,
  helpers,
}: let
  inherit (helpers) kernelModuleBlocked notApplicable optionEquals sysctlEquals;

  ipv6 = config.networking.enableIPv6;
  ipv6Sysctl = name: expected:
    if !ipv6
    then notApplicable "IPv6 is disabled in the evaluated NixOS configuration."
    else sysctlEquals name expected;
in {
  "3.1.3" = optionEquals {
    path = ["hardware" "bluetooth" "enable"];
    expected = false;
    remediation = "Set hardware.bluetooth.enable = false unless Bluetooth is required and excepted.";
    applicability = "adapted";
  };

  "3.2.1" = kernelModuleBlocked "atm";
  "3.2.2" = kernelModuleBlocked "can";
  "3.2.3" = kernelModuleBlocked "dccp";
  "3.2.4" = kernelModuleBlocked "rds";
  "3.2.5" = kernelModuleBlocked "sctp";
  "3.2.6" = kernelModuleBlocked "tipc";

  "3.3.1.2" = sysctlEquals "net.ipv4.conf.all.forwarding" 0;
  "3.3.1.3" = sysctlEquals "net.ipv4.conf.default.forwarding" 0;
  "3.3.1.4" = sysctlEquals "net.ipv4.conf.all.send_redirects" 0;
  "3.3.1.5" = sysctlEquals "net.ipv4.conf.default.send_redirects" 0;
  "3.3.1.6" = sysctlEquals "net.ipv4.icmp_ignore_bogus_error_responses" 1;
  "3.3.1.7" = sysctlEquals "net.ipv4.icmp_echo_ignore_broadcasts" 1;
  "3.3.1.8" = sysctlEquals "net.ipv4.conf.all.accept_redirects" 0;
  "3.3.1.9" = sysctlEquals "net.ipv4.conf.default.accept_redirects" 0;
  "3.3.1.10" = sysctlEquals "net.ipv4.conf.all.secure_redirects" 0;
  "3.3.1.11" = sysctlEquals "net.ipv4.conf.default.secure_redirects" 0;
  "3.3.1.12" = sysctlEquals "net.ipv4.conf.all.rp_filter" 1;
  "3.3.1.13" = sysctlEquals "net.ipv4.conf.default.rp_filter" 1;
  "3.3.1.14" = sysctlEquals "net.ipv4.conf.all.accept_source_route" 0;
  "3.3.1.15" = sysctlEquals "net.ipv4.conf.default.accept_source_route" 0;
  "3.3.1.16" = sysctlEquals "net.ipv4.conf.all.log_martians" 1;
  "3.3.1.17" = sysctlEquals "net.ipv4.conf.default.log_martians" 1;
  "3.3.1.18" = sysctlEquals "net.ipv4.tcp_syncookies" 1;

  "3.3.2.1" = ipv6Sysctl "net.ipv6.conf.all.forwarding" 0;
  "3.3.2.2" = ipv6Sysctl "net.ipv6.conf.default.forwarding" 0;
  "3.3.2.3" = ipv6Sysctl "net.ipv6.conf.all.accept_redirects" 0;
  "3.3.2.4" = ipv6Sysctl "net.ipv6.conf.default.accept_redirects" 0;
  "3.3.2.5" = ipv6Sysctl "net.ipv6.conf.all.accept_source_route" 0;
  "3.3.2.6" = ipv6Sysctl "net.ipv6.conf.default.accept_source_route" 0;
  "3.3.2.7" = ipv6Sysctl "net.ipv6.conf.all.accept_ra" 0;
  "3.3.2.8" = ipv6Sysctl "net.ipv6.conf.default.accept_ra" 0;
}
