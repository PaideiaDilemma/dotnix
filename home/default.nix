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

    ollama.enable = mkOption {
      default = false;
      description = "Whether to enable Ollama";
      type = types.bool;
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
        curl
        distrobox
        file
        gamescope
        git-moduletree
        grim
        imv
        jq
        jujutsu
        keepassxc
        lazyjj
        mako
        man-pages
        man-pages-posix
        mpv-unwrapped
        patchelfdd
        pavucontrol
        rofi-wayland
        rustup
        scrcpy
        slurp
        sqlite
        tinymist
        typst
        wget
        wl-clipboard
      ])
      ++ optionals (cfg.ollama.enable) (with pkgs; [
        ollama
      ])
      ++ optionals (cfg.gui.enable) (with pkgs; [
        # Graphical Applications
        #cutter
        #cutterPlugins.rz-ghidra
        #bottles - i need to look into nix-flatpak
        burpsuite
        chromium
        ghidra
        gnome-disk-utility
        inkscape
        krita
        libnotify.out
        libreoffice
        nwg-look
        pcmanfm
        spotify
        thunderbird
        vlc
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
        "text/html" = "firefox.desktop";
        "text/css" = "nvim.desktop";
        "application/octet-stream" = "re.rizin.cutter.desktop";
        "application/pdf" = "firefox.desktop";
        "application/json" = "nvim.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
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
        userName = cfg.fullName;
        userEmail = cfg.email;
      };
      nix-index.enable = true;
    };

    programs.home-manager.enable = true;

    home.stateVersion = "23.11";
  };
}
