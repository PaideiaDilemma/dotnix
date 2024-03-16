{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hyprhome;
  colors = config.colors;
in
{
  options.hyprhome.kdeApplications = {
    enable = mkOption {
      default = true;
      description = "Whether to enable KDE applications.";
      type = types.bool;
    };
  };

  config = mkIf (cfg.gui.enable && cfg.kdeApplications.enable) {
    home.packages = (with pkgs.kdePackages; [
      qtsvg
      breeze-icons
      dolphin
      dolphin-plugins
      ffmpegthumbs
      gwenview
      kdegraphics-thumbnailers
      kiconthemes
      kimageformats
      kio-extras
      kwayland
      layer-shell-qt
      qtimageformats
      qtpbfimageplugin
      qtwayland
      wayland
      wayland-protocols
    ]);

    services.kdeconnect.enable = true;

    xdg.configFile."kdeglobals".text = ''
      [General]
      TerminalApplication=${cfg.terminal}

      [Colors:View]
      BackgroundNormal=${colors.base.shade}

      [Icons]
      Theme=Penumbra
    '';
  };
}



