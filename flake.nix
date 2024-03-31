{
  description = "Personal NixOs flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprharpoon = {
      url = "github:PaideiaDilemma/hyprharpoon";
      inputs.hyprland.follows = "hyprland";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprlock = {
      url = "github:PaideiaDilemma/hyprlock/full-pam-conversation";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Collection of nix stuff we use at LosFuzzys.
    # I will try to convince them to make it public.
    los-nixpkgs = {
      url = "git+file:///home/max/desk/los-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Simplify once lazy trees are available https://github.com/NixOS/nix/pull/6530
    wlclipmgr.url = "git+https://www.github.com/PaideiaDilemma/wlclipmgr?submodules=1";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Community packages; used for Firefox extensions
    nur.url = "github:nix-community/nur";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    overlays = [
      inputs.nur.overlay
      (import ./overlays/deepin-cursors.nix)
      (import ./overlays/pwn-overlay.nix inputs)
      (import ./overlays/qtimageformats-overlay.nix)
      (import ./overlays/scripts-overlay.nix)
      (import ./overlays/way-displays-overlay.nix)
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
          inputs.nh.nixosModules.default
          ({...}: {
            users.users.${username} = {
              isNormalUser = true;
              extraGroups = ["wheel" "networkmanager" "audio" "video" "input"];
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
                inputs.hypridle.homeManagerModules.default
                inputs.hyprlock.homeManagerModules.default
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
          inputs.hypridle.homeManagerModules.default
          inputs.hyprlock.homeManagerModules.default
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
        nodePackages.prettier
      ];
    };

    formatter = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
