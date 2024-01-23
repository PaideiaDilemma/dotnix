{
  description = "Personal NixOs flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm = {
      url = "github:wez/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs:
    let
      mkNixos = hardware: host: userName: system:
        nixpkgs.lib.nixosSystem rec {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit hardware;
            inherit userName;
          };
          modules = [
            ./hardware/${hardware}.nix
            ./hosts/${host}
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${userName} = import ./home/home.nix;
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };

      mkHome = userName: pkgs:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            inherit userName;
          };
          modules = [
            hyprland.homeManagerModules.default
            ./home/home.nix
          ];
        };
    in
    {
      nixosConfigurations = {
        vm = mkNixos "vm1" "default" "max" "x86_64-linux";
        # currently it is handier for the username to just be "nixos"
        # https://discourse.nixos.org/t/set-default-user-in-wsl2-nixos-distro/38328/3
        wsl = mkNixos "none" "wsl" "nixos" "x86_64-linux";
      };

      homeConfigurations = {
        max = mkHome "max" nixpkgs.legacyPackages.x86_64-linux;
      };
    };
}





