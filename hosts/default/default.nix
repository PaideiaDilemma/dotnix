{ inputs, config, lib, pkgs, overlays, ... }:
{
  imports = [
    ./fonts
    ./virtualisation
    ./services
    ../../colors/penumbra.nix
  ];

  programs = {
    dconf.enable = true;
    git.enable = true;
    zsh.enable = true;
    virt-manager.enable = true;
    nix-ld.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #networking.hostName = hostName; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    colors = config.colors.console;
    earlySetup = true;
    keyMap = "de";
    #   useXkbConfig = true; # use xkb.options in tty.
    #   font = "Lat2-Terminus16";
  };

  # Enable sound.
  sound.enable = true;
  #hardware.pulseaudio.enable = true;

  environment.variables = {
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
    PATH = [
      "\${HOME}/.local/bin"
    ];
  };

  environment.systemPackages = with pkgs; [
    libevdev
    home-manager
  ];

  nixpkgs = {
    inherit overlays;
    config.allowUnfree = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    #enableSSHSupport = true;
  };

  security.polkit.enable = true;

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
    enable = true;
    channel = "https://nixos.org/channels/nixos-23.11";
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
}
