{
  description = "Personal NixOs flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprlock is part of the hyprland overlay, but i want it up to date for testing
    hyprlock = {
      url = "github:PaideiaDilemma/hyprlock?ref=greetdLogin";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland";
      #inputs.hyprutils.follows = "hyprland";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    lazyvim = {
      url = "github:PaideiaDilemma/LazyVim";
      flake = false;
    };

    git-moduletree = {
      url = "github:PaideiaDilemma/git-moduletree";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Simplify once lazy trees are available https://github.com/NixOS/nix/pull/6530
    wlclipmgr = {
      url = "git+https://www.github.com/PaideiaDilemma/wlclipmgr?submodules=1";
      #inputs.nixpkgs.follows = "nixpkgs"; // does not find procps for some reason
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Community packages; used for Firefox extensions
    nur.url = "github:nix-community/nur";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    overlays = [
      inputs.nur.overlays.default
      inputs.hyprland.overlays.default
      inputs.hyprlock.overlays.default
      (import ./overlays/deepin-cursors.nix)
      (import ./overlays/patchelfdd-overlay.nix)
      (import ./overlays/python-packages-overlay.nix)
      (import ./overlays/scripts-overlay.nix)
      (final: prev: {
        git-moduletree = inputs.git-moduletree.packages.${prev.system}.default;
      })
      (final: prev: {
        waybar = inputs.waybar.packages.${prev.system}.default;
      })
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
          ./host
          ./host/variants/${host}.nix
          home-manager.nixosModules.home-manager
          ({...}: {
            nix.registry.nixpkgs.flake = nixpkgs;
            users.users.${username} = {
              isNormalUser = true;
              extraGroups = ["wheel" "networkmanager" "audio" "video" "input" "dialout"];
            };
            users.users.root.password = "nixos";
            networking.hostName = "${hardware}";
          })
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${username} = {...}: {
              imports = [
                inputs.hyprland.homeManagerModules.default
                ./home
                ./home/variants/${homeVariant}.nix
              ];
              hyprhome.username = username;
            };
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
          inputs.hyprland.homeManagerModules.default
          ({...}: {
            imports = [./home ./home/variants/${homeVariant}.nix];
            hyprhome.username = username;
            nixpkgs = {
              config.allowUnfree = true;
              inherit overlays;
            };
          })
        ];
      };
  in {
    nixosConfigurations = {
      vm = mkNixos "vm1" "default" "generic" "max" "x86_64-linux";
      #iso = mkNixos "none" "default" "generic" "max" "x86_64-linux";

      laptop = mkNixos "laptop" "default" "laptop" "max" "x86_64-linux";
      desktop = mkNixos "desktop" "desktop" "desktop" "max" "x86_64-linux";
      # currently it is handier for the username to just be "nixos"
      # https://discourse.nixos.org/t/set-default-user-in-wsl2-nixos-distro/38328/3
      wsl = mkNixos "none" "wsl" "wsl" "nixos" "x86_64-linux";
    };

    # allow home-manager switch --flake .#configuration to work
    homeConfigurations = {
      "max@vm" = mkHome "generic" "max" nixpkgs.legacyPackages.x86_64-linux;
      "max@laptop" = mkHome "laptop" "max" nixpkgs.legacyPackages.x86_64-linux;
      "max@desktop" = mkHome "desktop" "max" nixpkgs.legacyPackages.x86_64-linux;
      "nixos@wsl" = mkHome "wsl" "nixos" nixpkgs.legacyPackages.x86_64-linux;
    };

    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      name = "dotnix";
      packages = with nixpkgs.legacyPackages.x86_64-linux; [
        alejandra
        git
      ];
    };

    formatter = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
