{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotnix;
in {
  imports = [
    ../colors/penumbra.nix
    ./programs
    ./theme
    ./shells
  ];

  home = {
    username = cfg.username;
    homeDirectory = "/home/${cfg.username}";
    enableDebugInfo = false;
  };

  home.packages =
    (with pkgs; [
      # Terminal Applications
      appimage-run
      btop
      catimg
      cryptsetup
      ctfd-downloader
      curl
      distrobox
      file
      inetutils
      jjui
      jq
      perf
      man-pages
      man-pages-posix
      mpv-unwrapped
      patchelfdd
      pavucontrol
      rustup
      scrcpy
      socat
      sqlite
      tinymist
      tree
      (pkgs.typst.withPackages (ps:
        with ps; [
          tableau-icons
          cetz_0_3_4
          oxifmt
          definitely-not-isec-slides
          polylux
        ]))
      usbutils
      wget
      wl-clipboard
      # Handy perf top alias with some defauls
      (writeShellScriptBin "perf-top" "perf top -K -g -H -e cycles -p $@")
    ])
    ++ lib.optionals (cfg.gui.enable) (with pkgs; [
      # Graphical Applications
      #cutter
      #cutterPlugins.rz-ghidra
      #bottles - i need to look into nix-flatpak
      audacious
      gamescope
      gnome-disk-utility
      grim
      imv
      inkscape
      jamesdsp
      keepassxc
      krita
      libnotify.out
      libreoffice
      mako
      nwg-look
      slurp
      thunderbird
      vlc
      wlr-randr
      nwg-displays
    ])
    ++ lib.optionals (cfg.gui.enable) (with pkgs.kdePackages; [
      # KDE Applications
      dolphin
    ])
    ++ lib.optionals (cfg.gui.enable) (with pkgs.gnome; [
      # Gnome Applications
    ]);

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/bmp" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";
      "image/tiff" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "video/mp4" = "vlc.desktop";
      "video/mpeg" = "vlc.desktop";
      "video/ogg" = "vlc.desktop";
      "video/webm" = "vlc.desktop";
      "audio/acc" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
      "audio/wav" = "mpv.desktop";
      "audio/webm" = "mpv.desktop";
      "text/plain" = "nvim.desktop";
      "text/xml" = "nvim.desktop";
      "text/html" = "firefox.desktop";
      "text/css" = "nvim.desktop";
      "application/octet-stream" = "re.rizin.cutter.desktop";
      "application/pdf" = "firefox.desktop";
      "application/json" = "nvim.desktop";
      "inode/directory" = "pcmanfm.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "x-scheme-handler/mailto" = "thunderbird.desktop";
    };
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "foot.desktop"
      ];
    };
  };

  xdg.userDirs = {
    enable = true;
    desktop = "${config.home.homeDirectory}/desk";
    documents = "${config.home.homeDirectory}/doc";
    music = "${config.home.homeDirectory}/media/music";
    pictures = "${config.home.homeDirectory}/media/picture";
    videos = "${config.home.homeDirectory}/media/video";
    publicShare = "${config.home.homeDirectory}/pub";
    templates = "${config.home.homeDirectory}/template";
    download = "${config.home.homeDirectory}/installf";
  };

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "ansi";
      };
    };
    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          name = cfg.fullName;
          email = cfg.email;
        };
      };
    };
    nix-index.enable = true;
  };

  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
