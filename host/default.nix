{ inputs, config, lib, pkgs, overlays, ... }:
with lib;
let
  cfg = config.host;
in
{
  imports = [
    ./fonts
    ./virtualisation
    ./services
    ../colors/penumbra.nix
  ];

  options.host = {
    gui.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable GUI?";
    };

    hyprland.enable = mkOption {
      type = types.bool;
      default = config.host.gui.enable;
      description = "Whether to enable Hyprland";
    };

    steam.enable = mkOption {
      type = types.bool;
      default = config.host.gui.enable;
      description = "Whether to enable Steam";
    };

    keyMap = mkOption {
      type = types.str;
      default = "de";
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
      zsh.enable = true;
      nix-ld.enable = true;
      gnupg.agent = {
        enable = true;
        #enableSSHSupport = true;
      };
      virt-manager.enable = cfg.gui.enable;
      dconf.enable = true;
      hyprland = {
        enable = (cfg.hyprland.enable && cfg.gui.enable);
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      };
      steam.enable = (cfg.steam.enable && cfg.gui.enable);
    };


    nixpkgs = {
      overlays = overlays ++ optionals (cfg.steam.enable && cfg.gui.enable) [
        (_: prev: {
          steam = prev.steam.override {
            extraProfile = "export STEAM_EXTRA_COMPAT_TOOLS_PATHS='${inputs.nix-gaming.packages.${pkgs.system}.proton-ge}'";
          };
        })
      ];

      config.allowUnfree = true;
    };

    xdg.portal = {
      enable = cfg.gui.enable;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };

    nh = {
      enable = true;
      clean.enable = true;
    };

    users.defaultUserShell = pkgs.zsh;

    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

    # Set your time zone.
    time.timeZone = "Europe/Vienna";

    zramSwap = {
      enable = true;
      memoryPercent = 100;
    };

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      colors = config.colors.console;
      earlySetup = true;
      keyMap = cfg.keyMap;
      #   useXkbConfig = true; # use xkb.options in tty.
      #   font = "Lat2-Terminus16";
    };

    # Enable sound.
    sound.enable = true;
    #hardware.pulseaudio.enable = true;

    environment.variables = {
      FLAKE = cfg.dotfileLocation;
      NIXOS_OZONE_WL = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      PATH = [
        "\${HOME}/.local/bin"
      ];
    };

    environment.systemPackages = with pkgs; [
      libevdev
      home-manager
    ] ++ optionals cfg.gui.enable [
      brightnessctl
    ];

    security.polkit.enable = true;
    security.pam.services.swaylock = {};

    # List services that you want to enable:

    networking.firewall = {
      enable = true;
      allowedTCPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];
      allowedUDPPortRanges = [
        { from = 1714; to = 1764; } # KDE Connect
      ];
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    system.autoUpgrade = {
      enable = false;
    };

    system.stateVersion = "23.11";

    nix = {
      package = pkgs.nixFlakes;
      settings = {
        substituters = [
          "https://cache.nixos.org/"
          "https://hyprland.cachix.org"
          "https://nix-gaming.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        ];

      };
      extraOptions = "experimental-features = nix-command flakes";
    };
  };
}
