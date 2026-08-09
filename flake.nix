{
  description = "Static CIS-aligned validation for NixOS evaluations";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    nixosModules = rec {
      nixos-cis-validator = import ./modules;
      default = nixos-cis-validator;
    };

    checks = import ./checks {inherit nixpkgs supportedSystems;};

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
