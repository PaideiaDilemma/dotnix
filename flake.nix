{
  description = "Personal NixOs flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  # TODO: Split into nixosConfigurations and homeConfigurations
  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs:
    let
      lib = nixpkgs.lib;
      opts = ({ lib, ... }: {
        options.deviceName = lib.mkOption {
          type = lib.types.str;
          default = "vm";
        };
      });
    in
    {
      nixosConfigurations = {
        vm = lib.nixosSystem rec {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            opts
            ./nixos/hardware-configuration-vm.nix
            ./nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.max = import ./home/home.nix;
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };
      };

      homeConfigurations = {
        max = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs; };
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            opts
            hyprland.homeManagerModules.default
            ./home/home.nix
          ];
        };
      };
    };
}
