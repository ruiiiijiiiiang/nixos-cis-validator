{
  config,
  helpers,
  ...
}: let
  firewall = helpers.mkStatic {
    actual = config.networking.firewall.enable;
    expected = true;
    option = "networking.firewall.enable";
    passed = config.networking.firewall.enable;
    applicability = "adapted";
    description = "The NixOS firewall replaces Ubuntu UFW and must be enabled with its default-deny input and forwarding policy.";
    remediation = "Set networking.firewall.enable = true and review explicitly allowed ports and interfaces.";
  };
in {
  "4.1.1" = firewall;
  "4.1.2" = firewall;
  "4.1.3" = firewall;
  "4.1.5" = firewall;
}
