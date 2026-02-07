{
  description = "Personal NixOs flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprutils = {
      url = "github:hyprwm/hyprutils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aquamarine = {
      url = "github:hyprwm/aquamarine";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprutils.follows = "hyprutils";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.aquamarine.follows = "aquamarine";
      inputs.hyprutils.follows = "hyprutils";
    };

    # hyprlock is part of the hyprland overlay, but i want it up to date for testing
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland";
      inputs.hyprutils.follows = "hyprutils";
    };

    # for greetd login via hyprlock
    hyprlock-greetd = {
      url = "github:PaideiaDilemma/hyprlock?ref=greetdLogin";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland";
      inputs.hyprutils.follows = "hyprutils";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland";
      inputs.hyprutils.follows = "hyprutils";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lazyvim = {
      url = "github:PaideiaDilemma/LazyVim";
      flake = false;
    };

    minimax = {
      url = "github:PaideiaDilemma/nvim-minimax";
      flake = false;
    };

    # libfprint-goodix = {
    #     url = "git+file:///home/max/desk/libfprint-goodix-dev";
    #   flake = false;
    # };

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
      #inputs.hyprland.overlays.hyprland-debug
      inputs.niri.overlays.niri

      (final: prev: {
        hyprlock = inputs.hyprlock.packages.${prev.stdenv.hostPlatform.system}.default;
        hyprlock-greetd = inputs.hyprlock-greetd.packages.${prev.stdenv.hostPlatform.system}.default;
        hypridle = inputs.hypridle.packages.${prev.stdenv.hostPlatform.system}.default;
      })
      (final: prev: {
        pwndbg = inputs.pwndbg.packages.${prev.stdenv.hostPlatform.system}.default;
        pwndbg-lldb = inputs.pwndbg.packages.${prev.stdenv.hostPlatform.system}.pwndbg-lldb;
      })
      (final: prev: {
        libfprint-goodix-dev = prev.libfprint.overrideAttrs(prevAttrs: {
          pname = "libfprint-goodix-dev";
          version = "0.0.1";
          buildInputs = prevAttrs.buildInputs ++ [ prev.nss prev.cmake ];
          src = inputs.libfprint-goodix;
          installCheckPhase = ""; # some crash when testing hwdb
        });

        fprintd-compat = prev.fprintd.overrideAttrs(prevAttrs: rec {
          version = "1.94.4";

          src = prev.fetchFromGitLab {
            domain = "gitlab.freedesktop.org";
            owner = "libfprint";
            repo = "fprintd";
            rev = "refs/tags/v${version}";
            hash = "sha256-B2g2d29jSER30OUqCkdk3+Hv5T3DA4SUKoyiqHb8FeU=";
          };
        });
        fprintd-goodix = final.fprintd-compat.override({ libfprint = final.libfprint-goodix-dev; });
      })
      (import ./overlays/fix-cmake-compat.nix) # TODO: remove
      (import ./overlays/deepin-cursors.nix)
      (import ./overlays/patchelfdd-overlay.nix)
      (import ./overlays/python-packages-overlay.nix)
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
          ./options
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
                ./options
                ./home
                ./home/variants/${homeVariant}.nix
              ];
              dotnix.username = username;
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
            imports = [
              ./options
              ./home
              ./home/variants/${homeVariant}.nix
              ];
            dotnix.username = username;
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

      laptop = mkNixos "laptop" "laptop" "laptop" "max" "x86_64-linux";
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

    formatter = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
