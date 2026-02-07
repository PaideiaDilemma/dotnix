{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotnix;
  colors = config.colors;
in {
  options.dotnix.kdeApplications = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable KDE applications.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf (cfg.gui.enable && cfg.kdeApplications.enable) {
    home.packages = with pkgs.kdePackages; [
      qtsvg
      breeze-icons
      #ffmpegthumbs
      #kdegraphics-thumbnailers
      #kiconthemes
      #kimageformats
      #kio-extras
      kwayland
      layer-shell-qt
      #qtimageformats
      #qtpbfimageplugin
      qtwayland
      wayland
      wayland-protocols
    ];

    services.kdeconnect.enable = true;

    xdg.configFile."kdeglobals".text = ''
      [General]
      TerminalApplication=${cfg.terminal}

      [Icons]
      Theme=Penumbra
    '';
  };
}
