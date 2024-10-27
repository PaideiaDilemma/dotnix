{
  inputs,
  config,
  lib,
  pkgs,
  overlays,
  ...
}:
with lib; let
  cfg = config.host;
in {
  imports = [
    ./fonts.nix
    ./virtualisation.nix
    ./network.nix
    ./services.nix
    ./sessions.nix
    ../colors/penumbra.nix
  ];

  options.host = {
    boot.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable boot services?";
    };

    gui.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable GUI?";
    };

    steam.enable = mkOption {
      type = types.bool;
      default = config.host.gui.enable;
      description = "Whether to enable Steam";
    };

    keyMap = mkOption {
      type = types.str;
      default = "us";
      description = "Console keymap";
    };

    dotfileLocation = mkOption {
      type = types.str;
      default = "\${HOME}/nixos-dotfiles";
      description = "Location of the dotfiles flake";
    };
  };

  config = {
    programs = {
      git.enable = true;
      adb.enable = true;
      zsh.enable = true;
      nix-ld.enable = true;
      gnupg.agent.enable = true;
      virt-manager.enable = cfg.gui.enable;
      dconf.enable = true;
      steam = {
        enable = cfg.steam.enable && cfg.gui.enable;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };

    nixpkgs = {
      overlays = overlays;
      config.allowUnfree = true;
    };

    xdg.portal = {
      enable = cfg.gui.enable;
      xdgOpenUsePortal = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      config = {
        common.default = ["gtk"];
        hyprland.default = ["gtk" "hyprland"];
      };
    };

    programs.nh = {
      enable = true;
      clean.enable = true;
    };

    users.defaultUserShell = pkgs.zsh;

    boot = lib.mkIf (cfg.boot.enable) {
      kernelPackages = pkgs.linuxPackages_latest;

      # Use the systemd-boot EFI boot loader.
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;

      kernel.sysctl = {
        "kernel.sysrq" = 1;
      };
    };

    # Set your time zone.
    time.timeZone = "Europe/Vienna";

    zramSwap = {
      enable = true;
      memoryPercent = 100;
    };

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      colors = config.colors.console;
      earlySetup = true;
      keyMap = cfg.keyMap;
      #   useXkbConfig = true; # use xkb.options in tty.
      #   font = "Lat2-Terminus16";
    };

    environment.variables = {
      FLAKE = cfg.dotfileLocation;
      NIXOS_OZONE_WL = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      PATH = [
        "\${HOME}/.local/bin"
      ];
    };

    environment.systemPackages = with pkgs;
      [
        libevdev
        home-manager
      ]
      ++ optionals cfg.gui.enable [
        brightnessctl
      ];

    security.polkit.enable = true;
    security.pam.services.swaylock = {};
    security.pam.services.hyprlock = {};

    system.autoUpgrade.enable = false;

    system.stateVersion = "23.11";

    nix = {
      nixPath = [
        "nixpkgs=${inputs.nixpkgs}"
      ];
      buildMachines = lib.filter (x: x.hostName != config.networking.hostName) [];
      distributedBuilds = true;
      package = pkgs.nixVersions.latest;
      settings = {
        substituters = [
          "https://cache.nixos.org/"
          "https://hyprland.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };
      extraOptions = "experimental-features = nix-command flakes";
    };
  };
}
