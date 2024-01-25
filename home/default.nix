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
  };

  config = {
    home = {
      username = cfg.username;
      homeDirectory = "/home/${cfg.username}";
      enableDebugInfo = false;
    };

    home.packages = (with pkgs; [

      # Terminal Applications
      wlr-randr
      git
      rustup
      gnumake
      catimg
      curl
      appimage-run
      mako
      pavucontrol
      sqlite
      file
      wget
      grim
      slurp
      btop
      rofi-wayland
      wl-clipboard
      imv
      scrcpy

    ]) ++ optionals (cfg.gui.enable) (with pkgs; [

      # Graphical Applications
      webcord
      bottles
      krita
      inkscape
      wdisplays
      libreoffice
      thunderbird
      ghidra
      cutter
      cutterPlugins.rz-ghidra
      burpsuite

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

    programs.home-manager.enable = true;

    home.stateVersion = "23.11";
  };
}
