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

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Simplify once lazy trees are available https://github.com/NixOS/nix/pull/6530
    wlclipmgr.url = "git+https://www.github.com/PaideiaDilemma/wlclipmgr?submodules=1";

    # Community packages; used for Firefox extensions
    nur.url = "github:nix-community/nur";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs:
    let
      overlays = [
        inputs.nur.overlay
        inputs.poetry2nix.overlays.default
        (import ./overlays/pear-white-cursors.nix)
        (import ./overlays/pwn-overlay.nix)
      ];

      mkNixos = hardware: host: homeVariant: username: system:
        nixpkgs.lib.nixosSystem rec {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit overlays;
          };
          modules = [
            ./hardware/${hardware}.nix
            ./hosts/${host}
            home-manager.nixosModules.home-manager
            inputs.nh.nixosModules.default
              ({ ... }: {
              users.users.${username} = {
                isNormalUser = true;
                extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" ];
              };
              users.users.root.password = "nixos";
              networking.hostName = "${hardware}";
            })
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
                inherit overlays;
                config.allowUnfree = true;
              };
            })
          ];
        };
    in
    {
      nixosConfigurations = {
        vm = mkNixos "vm1" "default" "generic" "max" "x86_64-linux";
        iso = mkNixos "none" "default" "generic" "max" "x86_64-linux";

        laptop = mkNixos "laptop" "default" "laptop" "max" "x86_64-linux";
        desktop = mkNixos "desktop" "default" "desktop" "max" "x86_64-linux";
        # currently it is handier for the username to just be "nixos"
        # https://discourse.nixos.org/t/set-default-user-in-wsl2-nixos-distro/38328/3
        wsl = mkNixos "none" "wsl" "nixos" "x86_64-linux";
      };

      # allow home-manager switch --flake .#configuration to work
      homeConfigurations = {
        vm = mkHome "generic" "max" nixpkgs.legacyPackages.x86_64-linux;
        "max@laptop" = mkHome "laptop" "max" nixpkgs.legacyPackages.x86_64-linux;
        "max@desktop" = mkHome "desktop" "max" nixpkgs.legacyPackages.x86_64-linux;
      };
    };
}
