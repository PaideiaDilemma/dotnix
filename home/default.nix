{ inputs, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hyprhome;
in
{
  imports = [
    ../colors/penumbra.nix
    ./programs
    ./scripts
    ./theme
    ./shells
  ];

  options.hyprhome = {
    gui = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable GUI?";
      };
    };

    username = mkOption {
      type = types.str;
      default = "max";
      description = "The user name";
    };

    terminal = mkOption {
      type = types.enum [ "foot" "wezterm" ];
      default = "foot";
      description = "The terminal emulator";
    };
  };

  config = {
    home = {
      username = cfg.username;
      homeDirectory = "/home/${cfg.username}";
      enableDebugInfo = false;
    };

    home.packages = (with pkgs; [

      # Terminal Applications
      appimage-run
      btop
      catimg
      cryptsetup
      curl
      distrobox
      file
      git
      gnumake
      grim
      imv
      mako
      pass-wayland
      pavucontrol
      rofi-wayland
      rustup
      scrcpy
      slurp
      sqlite
      wget
      wl-clipboard
      wlr-randr

    ]) ++ optionals (cfg.gui.enable) (with pkgs; [

      # Graphical Applications
      bottles
      burpsuite
      cutter
      cutterPlugins.rz-ghidra
      ghidra
      inkscape
      krita
      libreoffice
      thunderbird
      wdisplays
      webcord
      chromium

    ]) ++ optionals (cfg.gui.enable) (with pkgs.gnome; [
      gnome-tweaks
      eog
    ]);

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

    programs.git = {
      userName = "Maximilian Seidler";
      userEmail = "maximilian.seidler@soundwork.at";
    };

    programs.home-manager.enable = true;

    home.stateVersion = "23.11";
  };
}
