{ inputs, config, lib, pkgs, username, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    ./fonts
    ./virtualisation
    ./services
  ];

  wsl = {
    enable = true;
    startMenuLaunchers = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    wslConf.user.default = username;
    defaultUser = username;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };

  programs = {
    dconf.enable = true;
    git.enable = true;
    zsh.enable = true;
    virt-manager.enable = true;
  };

  nh = {
    enable = true;
    clean.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    keyMap = "de";
    #   useXkbConfig = true; # use xkb.options in tty.
    #   font = "Lat2-Terminus16";
  };

  # Enable sound.
  sound.enable = true;
  #hardware.pulseaudio.enable = true;

  environment.variables = {
    FLAKE = "\${HOME}/nixos-dotfiles";
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
    PATH = [
      "\${HOME}/.local/bin"
    ];
  };

  environment.systemPackages = with pkgs; [
    libevdev
  ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      neovim
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    #enableSSHSupport = true;
  };

  security.polkit.enable = true;

  # List services that you want to enable:

  networking.firewall.enable = false;

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
