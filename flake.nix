{
  description = "Personal NixOs flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aquamarine = {
      url = "github:hyprwm/aquamarine";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.aquamarine.follows = "aquamarine";
      inputs.hyprutils.follows = "aquamarine";
    };

    # hyprlock is part of the hyprland overlay, but i want it up to date for testing
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland";
      inputs.hyprutils.follows = "hyprland";
    };

    # for greetd login via hyprlock
    hyprlock-greetd = {
      url = "github:PaideiaDilemma/hyprlock?ref=greetdLogin";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland";
      inputs.hyprutils.follows = "hyprland";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland";
      inputs.hyprutils.follows = "hyprland";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    lazyvim = {
      url = "github:PaideiaDilemma/LazyVim";
      flake = false;
    };

    # Simplify once lazy trees are available https://github.com/NixOS/nix/pull/6530
    wlclipmgr = {
      url = "git+https://www.github.com/PaideiaDilemma/wlclipmgr?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:PaideiaDilemma/zen-browser-nix-build";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    pwndbg = {
      url = "github:pwndbg/pwndbg";
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
      inputs.hyprland.overlays.default

      (final: prev: {
        hyprland-debug = final.hyprland.override {
          aquamarine = final.aquamarine.override {debug = true;};
          hyprutils = final.hyprutils.override {debug = true;};
          debug = true;
        };
      })

      inputs.zen-browser.overlays.default
      inputs.wlclipmgr.overlays.default

      (final: prev: {
        hyprlock = inputs.hyprlock.packages.${prev.system}.default;
        hyprlock-greetd = inputs.hyprlock-greetd.packages.${prev.system}.default;
        hypridle = inputs.hypridle.packages.${prev.system}.default;
      })
      (final: prev: {
        pwndbg = inputs.pwndbg.packages.${prev.system}.default;
      })

      (final: prev: {
        foot = prev.foot.overrideAttrs {
          version = "latest";
          src = final.fetchFromGitea {
            domain = "codeberg.org";
            owner = "dnkl";
            repo = "foot";
            rev = "master";
            hash = "sha256-dFryKpvn7QJ2xLR37uc0QNij5PHNm/VD9LCwbo8nZMk=";
          };
        };
      })

      (import ./overlays/deepin-cursors.nix)
      (import ./overlays/patchelfdd-overlay.nix)
      (import ./overlays/python-packages-overlay.nix)
      (import ./overlays/scripts-overlay.nix)
      (import ./overlays/patchelfdd-overlay.nix)
      (import ./overlays/ctfd-downloader-overlay.nix)
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
      iso = mkNixos "minimal" "minimal" "minimal" "max" "x86_64-linux";
      vm = mkNixos "vm1" "minimal" "minimal" "max" "x86_64-linux";

      laptop = mkNixos "laptop" "default" "laptop" "max" "x86_64-linux";
      desktop = mkNixos "desktop" "desktop" "desktop" "max" "x86_64-linux";
      # currently it is handier for the username to just be "nixos"
      # https://discourse.nixos.org/t/set-default-user-in-wsl2-nixos-distro/38328/3
      wsl = mkNixos "minimal" "wsl" "wsl" "nixos" "x86_64-linux";
    };

    # allow home-manager switch --flake .#configuration to work
    homeConfigurations = {
      "max@vm" = mkHome "minimal" "max" nixpkgs.legacyPackages.x86_64-linux;
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
