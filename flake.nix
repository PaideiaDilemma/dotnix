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

    # Community packages; used for Firefox extensions
    nur.url = "github:nix-community/nur";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs:
    let
      mkNixos = hardware: host: homeVariant: username: system:
        nixpkgs.lib.nixosSystem rec {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hardware/${hardware}.nix
            ./hosts/${host}
            ({ ... }: {
              users.users.${username} = {
                isNormalUser = true;
                extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" ];
              };
            })
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.${username} = ({ ... }: {
                imports = [ ./home ./home/variants/${homeVariant}.nix ];
                hyprhome.username = username;
              });
            }
          ];
        };

      mkHome = homeVariant: username: pkgs:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [
            ({ ... }: {
              imports = [ ./home ./home/variants/${homeVariant}.nix ];
              hyprhome.username = username;
              nixpkgs = {
                config.allowUnfree = true;
                overlays = [ inputs.nur.overlay ];
              };
            })
          ];
        };
    in
    {
      nixosConfigurations = {
        vm = mkNixos "vm1" "default" "generic" "max" "x86_64-linux";
        iso = mkNixos "none" "default" "generic" "max" "x86_64-linux";
        # currently it is handier for the username to just be "nixos"
        # https://discourse.nixos.org/t/set-default-user-in-wsl2-nixos-distro/38328/3
        wsl = mkNixos "none" "wsl" "nixos" "x86_64-linux";
      };

      # allow home-manager switch --flake .#configuration to work
      homeConfigurations = {
        vm = mkHome "generic" "max" nixpkgs.legacyPackages.x86_64-linux;
      };
    };
}
