{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hyprhome;
in {
  imports = [
    ../colors/penumbra.nix
    ./programs
    ./theme
    ./shells
  ];

  options.hyprhome = {
    gui = {
      enable = mkOption {
        default = true;
        description = "Enable GUI?";
        type = types.bool;
      };

      staticMonitors = mkOption {
        type = types.attrsOf (types.attrsOf (types.str));
        default = {};
      };

      primaryMonitor = mkOption {
        default = "";
        description = "The primary monitor";
        type = types.str;
      };
    };

    username = mkOption {
      default = "max";
      description = "The user name";
      type = types.str;
    };

    fullName = mkOption {
      default = "Maximilian Seidler";
      description = "Full name";
      type = types.str;
    };

    email = mkOption {
      default = "maximilian.seidler@soundwork.at";
      description = "Email address";
      type = types.str;
    };

    terminal = mkOption {
      default = "foot";
      description = "Default terminal emulator";
      type = types.enum ["foot" "footclient"];
    };
  };

  config = {
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
      ++ optionals (cfg.gui.enable) (with pkgs; [
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
      ++ optionals (cfg.gui.enable) (with pkgs.kdePackages; [
        # KDE Applications
        kdenlive
        dolphin
      ])
      ++ optionals (cfg.gui.enable) (with pkgs.gnome; [
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
        "text/html" = "zen.desktop";
        "text/css" = "nvim.desktop";
        "application/octet-stream" = "re.rizin.cutter.desktop";
        "application/pdf" = "zen.desktop";
        "application/json" = "nvim.desktop";
        "inode/directory" = "pcmanfm.desktop";
        "x-scheme-handler/http" = "zen.desktop";
        "x-scheme-handler/https" = "zen.desktop";
        "x-scheme-handler/about" = "zen.desktop";
        "x-scheme-handler/unknown" = "zen.desktop";
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
  };
}
