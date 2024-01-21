{
  description = "Personal NixOs flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nix-gaming.url = "github:fufexan/nix-gaming";

    # TODO: Remove this once the PR is merged 
    wezterm = {
      url = "github:happenslol/wezterm?dir=nix&ref=add-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs:
    let
      mkNixos = hostname: username: system:
        nixpkgs.lib.nixosSystem rec {
          inherit system;
          specialArgs = {
            inherit inputs;
            hostname = hostname;
          };
          modules = [
            ./hardware/${hostname}.nix
            ./hosts/default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home/${username}.nix;
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };

      mkHome = username: pkgs:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            hyprland.homeManagerModules.default
            ./home/${username}.nix
          ];
        };
    in
    {
      nixosConfigurations = {
        vm = mkNixos "vm" "max" "x86_64-linux";
      };

      homeConfigurations = {
        max = mkHome "max" nixpkgs.legacyPackages.x86_64-linux;
      };
    };
}

