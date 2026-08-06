[
  {
    cisId = "1.1.1.1";
    assessment = "automated";
    title = "Ensure cramfs kernel module is not available";
  }
  {
    cisId = "1.1.1.2";
    assessment = "automated";
    title = "Ensure freevxfs kernel module is not available";
  }
  {
    cisId = "1.1.1.3";
    assessment = "automated";
    title = "Ensure hfs kernel module is not available";
  }
  {
    cisId = "1.1.1.4";
    assessment = "automated";
    title = "Ensure hfsplus kernel module is not available";
  }
  {
    cisId = "1.1.1.5";
    assessment = "automated";
    title = "Ensure jffs2 kernel module is not available";
  }
  {
    cisId = "1.1.1.9";
    assessment = "automated";
    title = "Ensure firewire-core kernel module is not available";
  }
  {
    cisId = "1.1.1.10";
    assessment = "automated";
    title = "Ensure usb-storage kernel module is not available";
  }
  {
    cisId = "1.1.1.11";
    assessment = "manual";
    title = "Ensure unused filesystems kernel modules are not available";
  }
  {
    cisId = "1.1.2.1.1";
    assessment = "automated";
    title = "Ensure /tmp is tmpfs or a separate partition";
  }
  {
    cisId = "1.1.2.1.2";
    assessment = "automated";
    title = "Ensure nodev option set on /tmp partition";
  }
  {
    cisId = "1.1.2.1.3";
    assessment = "automated";
    title = "Ensure nosuid option set on /tmp partition";
  }
  {
    cisId = "1.1.2.1.4";
    assessment = "automated";
    title = "Ensure noexec option set on /tmp partition";
  }
  {
    cisId = "1.1.2.2.1";
    assessment = "automated";
    title = "Ensure /dev/shm is tmpfs or a separate partition";
  }
  {
    cisId = "1.1.2.2.2";
    assessment = "automated";
    title = "Ensure nodev option set on /dev/shm partition";
  }
  {
    cisId = "1.1.2.2.3";
    assessment = "automated";
    title = "Ensure nosuid option set on /dev/shm partition";
  }
  {
    cisId = "1.1.2.2.4";
    assessment = "automated";
    title = "Ensure noexec option set on /dev/shm partition";
  }
  {
    cisId = "1.1.2.3.2";
    assessment = "automated";
    title = "Ensure nodev option set on /home partition";
  }
  {
    cisId = "1.1.2.3.3";
    assessment = "automated";
    title = "Ensure nosuid option set on /home partition";
  }
  {
    cisId = "1.1.2.4.2";
    assessment = "automated";
    title = "Ensure nodev option set on /var partition";
  }
  {
    cisId = "1.1.2.4.3";
    assessment = "automated";
    title = "Ensure nosuid option set on /var partition";
  }
  {
    cisId = "1.1.2.5.2";
    assessment = "automated";
    title = "Ensure nodev option set on /var/tmp partition";
  }
  {
    cisId = "1.1.2.5.3";
    assessment = "automated";
    title = "Ensure nosuid option set on /var/tmp partition";
  }
  {
    cisId = "1.1.2.5.4";
    assessment = "automated";
    title = "Ensure noexec option set on /var/tmp partition";
  }
  {
    cisId = "1.1.2.6.2";
    assessment = "automated";
    title = "Ensure nodev option set on /var/log partition";
  }
  {
    cisId = "1.1.2.6.3";
    assessment = "automated";
    title = "Ensure nosuid option set on /var/log partition";
  }
  {
    cisId = "1.1.2.6.4";
    assessment = "automated";
    title = "Ensure noexec option set on /var/log partition";
  }
  {
    cisId = "1.1.2.7.2";
    assessment = "automated";
    title = "Ensure nodev option set on /var/log/audit partition";
  }
  {
    cisId = "1.1.2.7.3";
    assessment = "automated";
    title = "Ensure nosuid option set on /var/log/audit partition";
  }
  {
    cisId = "1.1.2.7.4";
    assessment = "automated";
    title = "Ensure noexec option set on /var/log/audit partition";
  }
  {
    cisId = "1.2.1.1";
    assessment = "manual";
    title = "Ensure GPG keys are configured";
  }
  {
    cisId = "1.2.1.2";
    assessment = "automated";
    title = "Ensure gpgcheck is configured";
  }
  {
    cisId = "1.2.1.4";
    assessment = "manual";
    title = "Ensure package manager repositories are configured";
  }
  {
    cisId = "1.2.2.1";
    assessment = "manual";
    title = "Ensure updates, patches, and additional security software are installed";
  }
  {
    cisId = "1.3.1.1";
    assessment = "automated";
    title = "Ensure SELinux is installed";
  }
  {
    cisId = "1.3.1.2";
    assessment = "automated";
    title = "Ensure SELinux is not disabled in bootloader configuration";
  }
  {
    cisId = "1.3.1.3";
    assessment = "automated";
    title = "Ensure SELinux policy is configured";
  }
  {
    cisId = "1.3.1.4";
    assessment = "automated";
    title = "Ensure the SELinux mode is not disabled";
  }
  {
    cisId = "1.3.1.7";
    assessment = "automated";
    title = "Ensure the MCS Translation Service (mcstrans) is not installed";
  }
  {
    cisId = "1.3.1.8";
    assessment = "automated";
    title = "Ensure SETroubleshoot is not installed";
  }
  {
    cisId = "1.4.1";
    assessment = "automated";
    title = "Ensure bootloader password is set";
  }
  {
    cisId = "1.4.2";
    assessment = "automated";
    title = "Ensure access to bootloader config is configured";
  }
  {
    cisId = "1.5.1";
    assessment = "automated";
    title = "Ensure core file size is configured";
  }
  {
    cisId = "1.5.2";
    assessment = "automated";
    title = "Ensure fs.protected_hardlinks is configured";
  }
  {
    cisId = "1.5.4";
    assessment = "automated";
    title = "Ensure fs.suid_dumpable is configured";
  }
  {
    cisId = "1.5.5";
    assessment = "automated";
    title = "Ensure kernel.dmesg_restrict is configured";
  }
  {
    cisId = "1.5.6";
    assessment = "automated";
    title = "Ensure kernel.kptr_restrict is configured";
  }
  {
    cisId = "1.5.7";
    assessment = "automated";
    title = "Ensure kernel.yama.ptrace_scope is configured";
  }
  {
    cisId = "1.5.8";
    assessment = "automated";
    title = "Ensure kernel.randomize_va_space is configured";
  }
  {
    cisId = "1.5.9";
    assessment = "automated";
    title = "Ensure systemd-coredump ProcessSizeMax is configured";
  }
  {
    cisId = "1.5.10";
    assessment = "automated";
    title = "Ensure systemd-coredump Storage is configured";
  }
  {
    cisId = "1.6.1";
    assessment = "automated";
    title = "Ensure system wide crypto policy is not set to legacy";
  }
  {
    cisId = "1.6.2";
    assessment = "automated";
    title = "Ensure system wide crypto policy disables sha1 hash and signature support";
  }
  {
    cisId = "1.6.3";
    assessment = "automated";
    title = "Ensure system wide crypto policy macs are configured";
  }
  {
    cisId = "1.6.4";
    assessment = "automated";
    title = "Ensure system wide crypto policy disables cbc for ssh";
  }
  {
    cisId = "1.7.1";
    assessment = "automated";
    title = "Ensure /etc/motd is configured";
  }
  {
    cisId = "1.7.2";
    assessment = "automated";
    title = "Ensure /etc/issue is configured";
  }
  {
    cisId = "1.7.3";
    assessment = "automated";
    title = "Ensure /etc/issue.net is configured";
  }
  {
    cisId = "1.7.4";
    assessment = "automated";
    title = "Ensure access to /etc/motd is configured";
  }
  {
    cisId = "1.7.5";
    assessment = "automated";
    title = "Ensure access to /etc/issue is configured";
  }
  {
    cisId = "1.7.6";
    assessment = "automated";
    title = "Ensure access to /etc/issue.net is configured";
  }
  {
    cisId = "1.8.1";
    assessment = "automated";
    title = "Ensure GDM login banner is configured";
  }
  {
    cisId = "1.8.2";
    assessment = "automated";
    title = "Ensure GDM disable-user-list is configured";
  }
  {
    cisId = "1.8.3";
    assessment = "automated";
    title = "Ensure GDM screen lock is configured";
  }
  {
    cisId = "1.8.4";
    assessment = "automated";
    title = "Ensure GDM automount is configured";
  }
  {
    cisId = "1.8.5";
    assessment = "automated";
    title = "Ensure GDM autorun-never is configured";
  }
  {
    cisId = "2.1.1";
    assessment = "automated";
    title = "Ensure autofs services are not in use";
  }
  {
    cisId = "2.1.2";
    assessment = "automated";
    title = "Ensure avahi daemon services are not in use";
  }
  {
    cisId = "2.1.4";
    assessment = "automated";
    title = "Ensure dhcp server services are not in use";
  }
  {
    cisId = "2.1.5";
    assessment = "automated";
    title = "Ensure dns server services are not in use";
  }
  {
    cisId = "2.1.6";
    assessment = "automated";
    title = "Ensure dnsmasq services are not in use";
  }
  {
    cisId = "2.1.7";
    assessment = "automated";
    title = "Ensure ftp server services are not in use";
  }
  {
    cisId = "2.1.8";
    assessment = "automated";
    title = "Ensure message access server services are not in use";
  }
  {
    cisId = "2.1.9";
    assessment = "automated";
    title = "Ensure network file system services are not in use";
  }
  {
    cisId = "2.1.10";
    assessment = "automated";
    title = "Ensure print server services are not in use";
  }
  {
    cisId = "2.1.11";
    assessment = "automated";
    title = "Ensure rpcbind services are not in use";
  }
  {
    cisId = "2.1.12";
    assessment = "automated";
    title = "Ensure rsync services are not in use";
  }
  {
    cisId = "2.1.13";
    assessment = "automated";
    title = "Ensure samba file server services are not in use";
  }
  {
    cisId = "2.1.14";
    assessment = "automated";
    title = "Ensure snmp services are not in use";
  }
  {
    cisId = "2.1.15";
    assessment = "automated";
    title = "Ensure telnet server services are not in use";
  }
  {
    cisId = "2.1.16";
    assessment = "automated";
    title = "Ensure tftp server services are not in use";
  }
  {
    cisId = "2.1.17";
    assessment = "automated";
    title = "Ensure web proxy server services are not in use";
  }
  {
    cisId = "2.1.18";
    assessment = "automated";
    title = "Ensure web server services are not in use";
  }
  {
    cisId = "2.1.21";
    assessment = "automated";
    title = "Ensure mail transfer agents are configured for local-only mode";
  }
  {
    cisId = "2.1.22";
    assessment = "manual";
    title = "Ensure only approved services are listening on a network interface";
  }
  {
    cisId = "2.2.1";
    assessment = "automated";
    title = "Ensure ftp client is not installed";
  }
  {
    cisId = "2.2.3";
    assessment = "automated";
    title = "Ensure telnet client is not installed";
  }
  {
    cisId = "2.2.4";
    assessment = "automated";
    title = "Ensure tftp client is not installed";
  }
  {
    cisId = "2.3.1";
    assessment = "automated";
    title = "Ensure time synchronization is in use";
  }
  {
    cisId = "2.3.2";
    assessment = "automated";
    title = "Ensure chrony is configured";
  }
  {
    cisId = "2.3.3";
    assessment = "automated";
    title = "Ensure chrony is not run as the root user";
  }
  {
    cisId = "2.4.1.1";
    assessment = "automated";
    title = "Ensure cron daemon is enabled and active";
  }
  {
    cisId = "2.4.1.2";
    assessment = "automated";
    title = "Ensure access to /etc/crontab is configured";
  }
  {
    cisId = "2.4.1.3";
    assessment = "automated";
    title = "Ensure access to /etc/cron.hourly is configured";
  }
  {
    cisId = "2.4.1.4";
    assessment = "automated";
    title = "Ensure access to /etc/cron.daily is configured";
  }
  {
    cisId = "2.4.1.5";
    assessment = "automated";
    title = "Ensure access to /etc/cron.weekly is configured";
  }
  {
    cisId = "2.4.1.6";
    assessment = "automated";
    title = "Ensure access to /etc/cron.monthly is configured";
  }
  {
    cisId = "2.4.1.7";
    assessment = "automated";
    title = "Ensure access to /etc/cron.yearly is configured";
  }
  {
    cisId = "2.4.1.8";
    assessment = "automated";
    title = "Ensure access to /etc/cron.d is configured";
  }
  {
    cisId = "2.4.1.9";
    assessment = "automated";
    title = "Ensure access to crontab is configured";
  }
  {
    cisId = "2.4.2.1";
    assessment = "automated";
    title = "Ensure access to at is configured";
  }
  {
    cisId = "3.1.1";
    assessment = "manual";
    title = "Ensure IPv6 status is identified";
  }
  {
    cisId = "3.1.2";
    assessment = "automated";
    title = "Ensure wireless interfaces are not available";
  }
  {
    cisId = "3.1.3";
    assessment = "automated";
    title = "Ensure bluetooth services are not in use";
  }
  {
    cisId = "3.2.1";
    assessment = "automated";
    title = "Ensure atm kernel module is not available";
  }
  {
    cisId = "3.2.2";
    assessment = "automated";
    title = "Ensure can kernel module is not available";
  }
  {
    cisId = "3.2.3";
    assessment = "automated";
    title = "Ensure dccp kernel module is not available";
  }
  {
    cisId = "3.2.4";
    assessment = "automated";
    title = "Ensure tipc kernel module is not available";
  }
  {
    cisId = "3.2.5";
    assessment = "automated";
    title = "Ensure rds kernel module is not available";
  }
  {
    cisId = "3.2.6";
    assessment = "automated";
    title = "Ensure sctp kernel module is not available";
  }
  {
    cisId = "3.3.1.2";
    assessment = "automated";
    title = "Ensure net.ipv4.conf.all.forwarding is configured";
  }
  {
    cisId = "3.3.1.3";
    assessment = "automated";
    title = "Ensure net.ipv4.conf.default.forwarding is configured";
  }
  {
    cisId = "3.3.1.4";
    assessment = "automated";
    title = "Ensure net.ipv4.conf.all.send_redirects is configured";
  }
  {
    cisId = "3.3.1.5";
    assessment = "automated";
    title = "Ensure net.ipv4.conf.default.send_redirects is configured";
  }
  {
    cisId = "3.3.1.6";
    assessment = "automated";
    title = "Ensure net.ipv4.icmp_ignore_bogus_error_responses is configured";
  }
  {
    cisId = "3.3.1.7";
    assessment = "automated";
    title = "Ensure net.ipv4.icmp_echo_ignore_broadcasts is configured";
  }
  {
    cisId = "3.3.1.8";
    assessment = "automated";
    title = "Ensure net.ipv4.conf.all.accept_redirects is configured";
  }
  {
    cisId = "3.3.1.9";
    assessment = "automated";
    title = "Ensure net.ipv4.conf.default.accept_redirects is configured";
  }
  {
    cisId = "3.3.1.10";
    assessment = "automated";
    title = "Ensure net.ipv4.conf.all.secure_redirects is configured";
  }
  {
    cisId = "3.3.1.11";
    assessment = "automated";
    title = "Ensure net.ipv4.conf.default.secure_redirects is configured";
  }
  {
    cisId = "3.3.1.12";
    assessment = "automated";
    title = "Ensure net.ipv4.conf.all.rp_filter is configured";
  }
  {
    cisId = "3.3.1.13";
    assessment = "automated";
    title = "Ensure net.ipv4.conf.default.rp_filter is configured";
  }
  {
    cisId = "3.3.1.14";
    assessment = "automated";
    title = "Ensure net.ipv4.conf.all.accept_source_route is configured";
  }
  {
    cisId = "3.3.1.15";
    assessment = "automated";
    title = "Ensure net.ipv4.conf.default.accept_source_route is configured";
  }
  {
    cisId = "3.3.1.16";
    assessment = "automated";
    title = "Ensure net.ipv4.conf.all.log_martians is configured";
  }
  {
    cisId = "3.3.1.17";
    assessment = "automated";
    title = "Ensure net.ipv4.conf.default.log_martians is configured";
  }
  {
    cisId = "3.3.1.18";
    assessment = "automated";
    title = "Ensure net.ipv4.tcp_syncookies is configured";
  }
  {
    cisId = "3.3.2.1";
    assessment = "automated";
    title = "Ensure net.ipv6.conf.all.forwarding is configured";
  }
  {
    cisId = "3.3.2.2";
    assessment = "automated";
    title = "Ensure net.ipv6.conf.default.forwarding is configured";
  }
  {
    cisId = "3.3.2.3";
    assessment = "automated";
    title = "Ensure net.ipv6.conf.all.accept_redirects is configured";
  }
  {
    cisId = "3.3.2.4";
    assessment = "automated";
    title = "Ensure net.ipv6.conf.default.accept_redirects is configured";
  }
  {
    cisId = "3.3.2.5";
    assessment = "automated";
    title = "Ensure net.ipv6.conf.all.accept_source_route is configured";
  }
  {
    cisId = "3.3.2.6";
    assessment = "automated";
    title = "Ensure net.ipv6.conf.default.accept_source_route is configured";
  }
  {
    cisId = "3.3.2.7";
    assessment = "automated";
    title = "Ensure net.ipv6.conf.all.accept_ra is configured";
  }
  {
    cisId = "3.3.2.8";
    assessment = "automated";
    title = "Ensure net.ipv6.conf.default.accept_ra is configured";
  }
  {
    cisId = "4.1.1";
    assessment = "automated";
    title = "Ensure firewalld is installed";
  }
  {
    cisId = "4.1.2";
    assessment = "automated";
    title = "Ensure firewalld backend is configured";
  }
  {
    cisId = "4.1.3";
    assessment = "automated";
    title = "Ensure firewalld.service is configured";
  }
  {
    cisId = "4.1.4";
    assessment = "automated";
    title = "Ensure firewalld active zone target is configured";
  }
  {
    cisId = "4.1.5";
    assessment = "manual";
    title = "Ensure firewalld loopback traffic is configured";
  }
  {
    cisId = "4.1.6";
    assessment = "manual";
    title = "Ensure firewalld loopback source address traffic is configured";
  }
  {
    cisId = "4.1.7";
    assessment = "manual";
    title = "Ensure firewalld services and ports are configured";
  }
  {
    cisId = "5.1.1";
    assessment = "automated";
    title = "Ensure access to /etc/ssh/sshd_config is configured";
  }
  {
    cisId = "5.1.2";
    assessment = "automated";
    title = "Ensure access to SSH private host key files is configured";
  }
  {
    cisId = "5.1.3";
    assessment = "automated";
    title = "Ensure access to SSH public host key files is configured";
  }
  {
    cisId = "5.1.4";
    assessment = "automated";
    title = "Ensure sshd access is configured";
  }
  {
    cisId = "5.1.5";
    assessment = "automated";
    title = "Ensure sshd Banner is configured";
  }
  {
    cisId = "5.1.6";
    assessment = "automated";
    title = "Ensure sshd Ciphers are configured";
  }
  {
    cisId = "5.1.7";
    assessment = "automated";
    title = "Ensure sshd ClientAliveInterval and ClientAliveCountMax are configured";
  }
  {
    cisId = "5.1.10";
    assessment = "automated";
    title = "Ensure sshd HostbasedAuthentication is disabled";
  }
  {
    cisId = "5.1.11";
    assessment = "automated";
    title = "Ensure sshd IgnoreRhosts is enabled";
  }
  {
    cisId = "5.1.12";
    assessment = "automated";
    title = "Ensure sshd KexAlgorithms is configured";
  }
  {
    cisId = "5.1.13";
    assessment = "automated";
    title = "Ensure sshd LoginGraceTime is configured";
  }
  {
    cisId = "5.1.14";
    assessment = "automated";
    title = "Ensure sshd LogLevel is configured";
  }
  {
    cisId = "5.1.15";
    assessment = "automated";
    title = "Ensure sshd MACs are configured";
  }
  {
    cisId = "5.1.16";
    assessment = "automated";
    title = "Ensure sshd MaxAuthTries is configured";
  }
  {
    cisId = "5.1.17";
    assessment = "automated";
    title = "Ensure sshd MaxStartups is configured";
  }
  {
    cisId = "5.1.18";
    assessment = "automated";
    title = "Ensure sshd MaxSessions is configured";
  }
  {
    cisId = "5.1.19";
    assessment = "automated";
    title = "Ensure sshd PermitEmptyPasswords is disabled";
  }
  {
    cisId = "5.1.20";
    assessment = "automated";
    title = "Ensure sshd PermitRootLogin is disabled";
  }
  {
    cisId = "5.1.21";
    assessment = "automated";
    title = "Ensure sshd PermitUserEnvironment is disabled";
  }
  {
    cisId = "5.1.22";
    assessment = "automated";
    title = "Ensure sshd UsePAM is enabled";
  }
  {
    cisId = "5.2.1";
    assessment = "automated";
    title = "Ensure sudo is installed";
  }
  {
    cisId = "5.2.2";
    assessment = "automated";
    title = "Ensure sudo commands use pty";
  }
  {
    cisId = "5.2.3";
    assessment = "automated";
    title = "Ensure sudo log file exists";
  }
  {
    cisId = "5.2.5";
    assessment = "automated";
    title = "Ensure re-authentication for privilege escalation is not disabled globally";
  }
  {
    cisId = "5.2.6";
    assessment = "automated";
    title = "Ensure sudo timestamp_timeout is configured";
  }
  {
    cisId = "5.2.7";
    assessment = "automated";
    title = "Ensure access to the su command is restricted";
  }
  {
    cisId = "5.3.1.1";
    assessment = "automated";
    title = "Ensure active authselect profile includes pam modules";
  }
  {
    cisId = "5.3.1.2";
    assessment = "automated";
    title = "Ensure pam_faillock module is enabled";
  }
  {
    cisId = "5.3.1.3";
    assessment = "automated";
    title = "Ensure pam_pwquality module is enabled";
  }
  {
    cisId = "5.3.1.4";
    assessment = "automated";
    title = "Ensure pam_pwhistory module is enabled";
  }
  {
    cisId = "5.3.1.5";
    assessment = "automated";
    title = "Ensure pam_unix module is enabled";
  }
  {
    cisId = "5.3.2.1.1";
    assessment = "automated";
    title = "Ensure password failed attempts lockout is configured";
  }
  {
    cisId = "5.3.2.1.2";
    assessment = "automated";
    title = "Ensure password unlock time is configured";
  }
  {
    cisId = "5.3.2.2.1";
    assessment = "automated";
    title = "Ensure password number of changed characters is configured";
  }
  {
    cisId = "5.3.2.2.2";
    assessment = "automated";
    title = "Ensure password length is configured";
  }
  {
    cisId = "5.3.2.2.3";
    assessment = "manual";
    title = "Ensure password complexity is configured";
  }
  {
    cisId = "5.3.2.2.4";
    assessment = "automated";
    title = "Ensure password same consecutive characters is configured";
  }
  {
    cisId = "5.3.2.2.5";
    assessment = "automated";
    title = "Ensure password maximum sequential characters is configured";
  }
  {
    cisId = "5.3.2.2.6";
    assessment = "automated";
    title = "Ensure password dictionary check is enabled";
  }
  {
    cisId = "5.3.2.2.7";
    assessment = "automated";
    title = "Ensure password quality is enforced for the root user";
  }
  {
    cisId = "5.3.2.3.1";
    assessment = "automated";
    title = "Ensure password history remember is configured";
  }
  {
    cisId = "5.3.2.3.2";
    assessment = "automated";
    title = "Ensure password history is enforced for the root user";
  }
  {
    cisId = "5.3.2.3.3";
    assessment = "automated";
    title = "Ensure pam_pwhistory includes use_authtok";
  }
  {
    cisId = "5.3.2.4.1";
    assessment = "automated";
    title = "Ensure pam_unix does not include nullok";
  }
  {
    cisId = "5.3.2.4.2";
    assessment = "automated";
    title = "Ensure pam_unix does not include remember";
  }
  {
    cisId = "5.3.2.4.3";
    assessment = "automated";
    title = "Ensure pam_unix includes a strong password hashing algorithm";
  }
  {
    cisId = "5.3.2.4.4";
    assessment = "automated";
    title = "Ensure pam_unix includes use_authtok";
  }
  {
    cisId = "5.4.1.1";
    assessment = "automated";
    title = "Ensure password expiration is configured";
  }
  {
    cisId = "5.4.1.3";
    assessment = "automated";
    title = "Ensure password expiration warning days is configured";
  }
  {
    cisId = "5.4.1.4";
    assessment = "automated";
    title = "Ensure strong password hashing algorithm is configured";
  }
  {
    cisId = "5.4.1.5";
    assessment = "automated";
    title = "Ensure inactive password lock is configured";
  }
  {
    cisId = "5.4.1.6";
    assessment = "automated";
    title = "Ensure all users last password change date is in the past";
  }
  {
    cisId = "5.4.2.1";
    assessment = "automated";
    title = "Ensure root is the only UID 0 account";
  }
  {
    cisId = "5.4.2.2";
    assessment = "automated";
    title = "Ensure root is the only GID 0 account";
  }
  {
    cisId = "5.4.2.3";
    assessment = "automated";
    title = "Ensure group root is the only GID 0 group";
  }
  {
    cisId = "5.4.2.4";
    assessment = "automated";
    title = "Ensure root account access is controlled";
  }
  {
    cisId = "5.4.2.5";
    assessment = "automated";
    title = "Ensure root path integrity";
  }
  {
    cisId = "5.4.2.6";
    assessment = "automated";
    title = "Ensure root user umask is configured";
  }
  {
    cisId = "5.4.2.7";
    assessment = "automated";
    title = "Ensure system accounts do not have a valid login shell";
  }
  {
    cisId = "5.4.2.8";
    assessment = "automated";
    title = "Ensure accounts without a valid login shell are locked";
  }
  {
    cisId = "5.4.3.2";
    assessment = "automated";
    title = "Ensure default user shell timeout is configured";
  }
  {
    cisId = "5.4.3.3";
    assessment = "automated";
    title = "Ensure default user umask is configured";
  }
  {
    cisId = "6.1.1";
    assessment = "automated";
    title = "Ensure AIDE is installed";
  }
  {
    cisId = "6.1.2";
    assessment = "automated";
    title = "Ensure filesystem integrity is regularly checked";
  }
  {
    cisId = "6.1.3";
    assessment = "automated";
    title = "Ensure cryptographic mechanisms are used to protect the integrity of audit tools";
  }
  {
    cisId = "6.2.1.1";
    assessment = "automated";
    title = "Ensure journald service is active";
  }
  {
    cisId = "6.2.1.2";
    assessment = "manual";
    title = "Ensure journald log file access is configured";
  }
  {
    cisId = "6.2.1.3";
    assessment = "manual";
    title = "Ensure journald log file rotation is configured";
  }
  {
    cisId = "6.2.1.4";
    assessment = "automated";
    title = "Ensure only one logging system is in use";
  }
  {
    cisId = "6.2.2.1.1";
    assessment = "automated";
    title = "Ensure systemd-journal-remote is installed";
  }
  {
    cisId = "6.2.2.1.2";
    assessment = "manual";
    title = "Ensure systemd-journal-upload authentication is configured";
  }
  {
    cisId = "6.2.2.1.3";
    assessment = "automated";
    title = "Ensure systemd-journal-upload is enabled and active";
  }
  {
    cisId = "6.2.2.1.4";
    assessment = "automated";
    title = "Ensure systemd-journal-remote service is not in use";
  }
  {
    cisId = "6.2.2.2";
    assessment = "automated";
    title = "Ensure journald ForwardToSyslog is disabled";
  }
  {
    cisId = "6.2.2.3";
    assessment = "automated";
    title = "Ensure journald Compress is configured";
  }
  {
    cisId = "6.2.2.4";
    assessment = "automated";
    title = "Ensure journald Storage is configured";
  }
  {
    cisId = "6.2.3.1";
    assessment = "automated";
    title = "Ensure rsyslog is installed";
  }
  {
    cisId = "6.2.3.2";
    assessment = "automated";
    title = "Ensure rsyslog service is enabled and active";
  }
  {
    cisId = "6.2.3.3";
    assessment = "automated";
    title = "Ensure journald is configured to send logs to rsyslog";
  }
  {
    cisId = "6.2.3.4";
    assessment = "automated";
    title = "Ensure rsyslog log file creation mode is configured";
  }
  {
    cisId = "6.2.3.5";
    assessment = "manual";
    title = "Ensure rsyslog logging is configured";
  }
  {
    cisId = "6.2.3.6";
    assessment = "manual";
    title = "Ensure rsyslog is configured to send logs to a remote log host";
  }
  {
    cisId = "6.2.3.7";
    assessment = "automated";
    title = "Ensure rsyslog is not configured to receive logs from a remote client";
  }
  {
    cisId = "6.2.3.8";
    assessment = "manual";
    title = "Ensure rsyslog logrotate is configured";
  }
  {
    cisId = "6.2.4.1";
    assessment = "automated";
    title = "Ensure access to all logfiles has been configured";
  }
  {
    cisId = "7.1.1";
    assessment = "automated";
    title = "Ensure access to /etc/passwd is configured";
  }
  {
    cisId = "7.1.2";
    assessment = "automated";
    title = "Ensure access to /etc/passwd- is configured";
  }
  {
    cisId = "7.1.3";
    assessment = "automated";
    title = "Ensure access to /etc/group is configured";
  }
  {
    cisId = "7.1.4";
    assessment = "automated";
    title = "Ensure access to /etc/group- is configured";
  }
  {
    cisId = "7.1.5";
    assessment = "automated";
    title = "Ensure access to /etc/shadow is configured";
  }
  {
    cisId = "7.1.6";
    assessment = "automated";
    title = "Ensure access to /etc/shadow- is configured";
  }
  {
    cisId = "7.1.7";
    assessment = "automated";
    title = "Ensure access to /etc/gshadow is configured";
  }
  {
    cisId = "7.1.8";
    assessment = "automated";
    title = "Ensure access to /etc/gshadow- is configured";
  }
  {
    cisId = "7.1.9";
    assessment = "automated";
    title = "Ensure access to /etc/shells is configured";
  }
  {
    cisId = "7.1.10";
    assessment = "automated";
    title = "Ensure access to /etc/security/opasswd is configured";
  }
  {
    cisId = "7.1.11";
    assessment = "automated";
    title = "Ensure world writable files and directories are secured";
  }
  {
    cisId = "7.1.12";
    assessment = "automated";
    title = "Ensure no files or directories without an owner and a group exist";
  }
  {
    cisId = "7.1.13";
    assessment = "manual";
    title = "Ensure SUID and SGID files are reviewed";
  }
  {
    cisId = "7.2.1";
    assessment = "automated";
    title = "Ensure accounts in /etc/passwd use shadowed passwords";
  }
  {
    cisId = "7.2.2";
    assessment = "automated";
    title = "Ensure /etc/shadow password fields are not empty";
  }
  {
    cisId = "7.2.3";
    assessment = "automated";
    title = "Ensure all groups in /etc/passwd exist in /etc/group";
  }
  {
    cisId = "7.2.4";
    assessment = "automated";
    title = "Ensure no duplicate UIDs exist";
  }
  {
    cisId = "7.2.5";
    assessment = "automated";
    title = "Ensure no duplicate GIDs exist";
  }
  {
    cisId = "7.2.6";
    assessment = "automated";
    title = "Ensure no duplicate user names exist";
  }
  {
    cisId = "7.2.7";
    assessment = "automated";
    title = "Ensure no duplicate group names exist";
  }
  {
    cisId = "7.2.8";
    assessment = "automated";
    title = "Ensure local interactive user home directories are configured";
  }
  {
    cisId = "7.2.9";
    assessment = "automated";
    title = "Ensure local interactive user dot files access is configured";
  }
]
