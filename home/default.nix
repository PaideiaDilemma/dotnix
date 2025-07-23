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
    ./environment.nix
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
        bat
        btop
        catimg
        cryptsetup
        ctfd-downloader
        curl
        distrobox
        file
        jjui
        jq
        linuxPackages_latest.perf
        man-pages
        man-pages-posix
        mpv-unwrapped
        patchelfdd
        pavucontrol
        rustup
        scrcpy
        sqlite
        tinymist
        tree
        typst
        usbutils
        uv
        wget
        wl-clipboard
      ])
      ++ optionals (cfg.gui.enable) (with pkgs; [
        # Graphical Applications
        #cutter
        #cutterPlugins.rz-ghidra
        #bottles - i need to look into nix-flatpak
        burpsuite
        chromium
        zen-browser
        gamescope
        ghidra
        gnome-disk-utility
        grim
        imv
        inkscape
        keepassxc
        krita
        libnotify.out
        libreoffice
        mako
        nwg-look
        nemo
        slurp
        spotify
        thunderbird
        vlc
        wdisplays
        webcord
        wlr-randr
      ])
      ++ optionals (cfg.gui.enable) (with pkgs.kdePackages; [
        # KDE Applications
        kdenlive
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

    xdg.configFile."user-dirs.dirs".text = ''
      XDG_DESKTOP_DIR="$HOME/desk"
      XDG_DOCUMENTS_DIR="$HOME/doc"
      XDG_MUSIC_DIR="$HOME/media/music"
      XDG_PICTURES_DIR="$HOME/media/picture"
      XDG_PUBLICSHARE_DIR="$HOME/pub"
      XDG_TEMPLATES_DIR="$HOME/template"
      XDG_VIDEOS_DIR="$HOME/media/video"
      XDG_DOWNLOAD_DIR="$HOME/installf"
    '';

    programs = {
      git = {
        enable = true;
        lfs.enable = true;
        userName = cfg.fullName;
        userEmail = cfg.email;
      };
      nix-index.enable = true;
    };

    programs.home-manager.enable = true;

    home.stateVersion = "23.11";
  };
}
