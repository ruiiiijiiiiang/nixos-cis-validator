{
  config,
  lib,
  profile,
}: let
  mergeMappings = lib.foldl' (acc: mappings: acc // mappings) {};
  helpers = import ./lib.nix {inherit config lib;};

  baseMappings = mergeMappings [
    (import ./section-1.nix {inherit config helpers lib;})
    (import ./section-2.nix {inherit config helpers lib;})
    (import ./section-3.nix {inherit config helpers lib;})
    (import ./section-4.nix {inherit config helpers lib;})
    (import ./section-5.nix {inherit config helpers lib;})
    (import ./section-6.nix {inherit config helpers lib;})
  ];

  baseNotApplicable = {
    "1.2.1.1" = "NixOS does not use APT source files or the APT Signed-By mechanism.";
    "1.2.1.2" = "NixOS does not use APT weak-dependency configuration.";
    "1.2.1.3" = "NixOS does not use APT GPG key files.";
    "1.2.1.4" = "NixOS does not use /etc/apt/trusted.gpg.d.";
    "1.2.1.5" = "NixOS does not use /etc/apt/auth.conf.d.";
    "1.2.1.6" = "NixOS does not use APT authentication configuration files.";
    "1.2.1.7" = "NixOS package trust is not configured through /usr/share/keyrings.";
    "1.2.1.8" = "NixOS does not use /etc/apt/sources.list.d.";
    "1.2.1.9" = "NixOS does not use APT source-list files.";
    "1.5.7" = "Ubuntu apport automatic error reporting is not part of NixOS.";
  };

  baseRuntime = {
    "1.2.2.1" = "Update and vulnerability status depends on the deployed flake inputs and running generation.";
    "1.4.1" = "Bootloader authentication cannot be inferred portably across supported NixOS bootloaders.";
    "1.4.2" = "Bootloader file ownership and modes require inspection of the built or deployed boot filesystem.";
    "2.1.4" = "Approved listening services require site policy and observation of the running host.";
    "2.2.1" = "Installed NIS client programs must be inspected in the built system closure or running generation.";
    "2.2.2" = "Installed rsh client programs must be inspected in the built system closure or running generation.";
    "2.2.3" = "Installed talk client programs must be inspected in the built system closure or running generation.";
    "2.2.4" = "Installed telnet client programs must be inspected in the built system closure or running generation.";
    "2.2.5" = "Installed LDAP client programs must be inspected in the built system closure or running generation.";
    "2.2.6" = "Installed FTP client programs must be inspected in the built system closure or running generation.";
    "2.4.1.2" = "The effective ownership and mode of /etc/crontab requires build-artifact or runtime inspection.";
    "2.4.1.3" = "The effective ownership and mode of /etc/cron.hourly requires build-artifact or runtime inspection.";
    "2.4.1.4" = "The effective ownership and mode of /etc/cron.daily requires build-artifact or runtime inspection.";
    "2.4.1.5" = "The effective ownership and mode of /etc/cron.weekly requires build-artifact or runtime inspection.";
    "2.4.1.6" = "The effective ownership and mode of /etc/cron.monthly requires build-artifact or runtime inspection.";
    "2.4.1.7" = "The effective ownership and mode of /etc/cron.yearly requires build-artifact or runtime inspection.";
    "2.4.1.8" = "The effective ownership and mode of /etc/cron.d requires build-artifact or runtime inspection.";
    "2.4.1.9" = "Cron authorization files require build-artifact or runtime inspection.";
    "2.4.2.1" = "At authorization files require build-artifact or runtime inspection.";
    "3.1.1" = "The benchmark explicitly requires documenting the environment's intended IPv6 state.";
    "3.1.2" = "Wireless hardware availability cannot be proven from a generic NixOS evaluation.";
    "5.1.1" = "Effective OpenSSH configuration-file ownership and mode require build-artifact or runtime inspection.";
    "5.1.2" = "SSH private host-key ownership and modes require build-artifact or runtime inspection.";
    "5.1.3" = "SSH public host-key ownership and modes require build-artifact or runtime inspection.";
    "5.3.1.2" = "The benchmark's PAM package state does not map directly to a NixOS evaluation invariant.";
    "5.3.1.3" = "The presence and version of pam_pwquality requires inspection of the generated PAM closure.";
    "5.3.1.4" = "The presence and version of cracklib requires inspection of the generated PAM closure.";
    "5.4.1.6" = "Existing users' last password-change dates are mutable runtime state.";
    "5.4.2.2" = "Effective primary GIDs in /etc/passwd require inspection after NixOS user activation.";
    "5.4.2.4" = "Root account credential state requires inspection of the deployed shadow database.";
    "5.4.2.5" = "Root PATH integrity depends on the runtime login environment.";
    "5.4.2.6" = "Root's effective umask depends on runtime shell and PAM configuration.";
    "5.4.2.7" = "Effective shells for all system accounts require inspection after user activation.";
    "5.4.2.8" = "Lock state for non-login accounts is stored in the deployed shadow database.";
    "6.1.1.1.4" = "Journal file ownership and modes require inspection of the built or running filesystem.";
    "6.1.1.1.5" = "Effective journal retention must be assessed against site capacity and retention policy.";
    "6.1.2.4" = "Required rsyslog destinations depend on site logging policy and generated runtime configuration.";
    "6.1.2.5" = "The approved remote log destination is site-specific and requires runtime connectivity validation.";
    "6.1.2.7" = "Effective log rotation requires inspection of generated configuration and runtime policy.";
    "6.1.3.1" = "Ownership and modes of all deployed log files require runtime filesystem inspection.";
    "6.3.1" = "AIDE presence must be validated in the built closure until a native NixOS AIDE module is available.";
    "6.3.2" = "Filesystem-integrity scheduling and successful execution require build-artifact and runtime validation.";
  };

  ubuntuCatalog = import ../catalog/ubuntu-24.04-v2.0.0-l1-server.nix;
  ubuntuIdByTitle = builtins.listToAttrs (map (entry: lib.nameValuePair entry.title entry.cisId) ubuntuCatalog);

  inheritByTitle = results:
    builtins.listToAttrs (
      builtins.filter (item: item != null) (
        map (
          entry: let
            ubuntuId = ubuntuIdByTitle.${entry.title} or null;
          in
            if ubuntuId != null && builtins.hasAttr ubuntuId results
            then lib.nameValuePair entry.cisId results.${ubuntuId}
            else null
        )
        profile.catalog
      )
    );

  family = import ./families/${profile.internal.evaluatorFamily}.nix {inherit config helpers lib;};
  isUbuntu = profile.id == "ubuntu-24.04-l1-server";
in {
  mappings =
    (
      if isUbuntu
      then baseMappings
      else inheritByTitle baseMappings
    )
    // family.mappings;
  notApplicable =
    (
      if isUbuntu
      then baseNotApplicable
      else inheritByTitle baseNotApplicable
    )
    // family.notApplicable;
  runtime =
    (
      if isUbuntu
      then baseRuntime
      else inheritByTitle baseRuntime
    )
    // family.runtime;
  runtimePrefixes = ["7."];
}
