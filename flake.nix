{
  description = "Personal NixOs flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprutils = {
      url = "github:PaideiaDilemma/hyprutils?ref=atomic-control-block";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprutils.follows = "hyprutils";
    };

    # hyprlock is part of the hyprland overlay, but i want it up to date for testing
    hyprlock = {
      url = "github:hyprwm/hyprlock";
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

    # greetd login via hyprlock
    hyprlock-greetd = {
      url = "github:PaideiaDilemma/hyprlock?ref=greetdLogin";
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
      #inputs.nixpkgs.follows = "nixpkgs"; // does not find procps for some reason
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
      # TODO: renable
      #inputs.hyprland.overlays.default
      # TODO: remove
      inputs.hyprland.inputs.hyprcursor.overlays.default
      inputs.hyprland.inputs.aquamarine.overlays.default
      inputs.hyprland.inputs.hyprutils.overlays.default
      inputs.hyprland.inputs.hyprlang.overlays.default
      inputs.hyprland.inputs.hyprgraphics.overlays.default
      inputs.hyprland.inputs.hyprwayland-scanner.overlays.default
      inputs.hyprland.inputs.xdph.overlays.default
      inputs.hyprland.overlays.udis86
      (final: prev: {
        wayland-protocols-bump = prev.wayland-protocols.overrideAttrs (self: super: {
          version = "1.43";

          src = final.fetchurl {
            url = "https://gitlab.freedesktop.org/wayland/${self.pname}/-/releases/${self.version}/downloads/${self.pname}-${self.version}.tar.xz";
            hash = "sha256-ujw0Jd0nxXtSkek9upe+EkeWAeALyrJNJkcZSMtkNlM=";
          };
        });
        hyprland = inputs.hyprland.packages.${prev.system}.default.overrideAttrs (oldAttrs: {
          buildInputs = [final.wayland-protocols-bump] ++ oldAttrs.buildInputs;
        });
        hyprland-debug = inputs.hyprland.packages.${prev.system}.hyprland-debug.overrideAttrs (oldAttrs: {
          buildInputs = [final.wayland-protocols-bump] ++ oldAttrs.buildInputs;
        });
        xdph = inputs.hyprland.packages.${prev.system}.xdph;
      })
      # remove end

      (final: prev: {
        hyprlock = inputs.hyprlock.packages.${prev.system}.default;
        hyprlock-greetd = inputs.hyprlock-greetd.packages.${prev.system}.default;
        hypridle = inputs.hypridle.packages.${prev.system}.default;
      })
      (import ./overlays/deepin-cursors.nix)
      (import ./overlays/patchelfdd-overlay.nix)
      (import ./overlays/python-packages-overlay.nix)
      (import ./overlays/scripts-overlay.nix)
      (import ./overlays/patchelfdd-overlay.nix)
      (import ./overlays/ctfd-downloader-overlay.nix)
      (final: prev: {
        pwndbg = inputs.pwndbg.packages.${prev.system}.default;
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
