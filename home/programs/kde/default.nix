{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hyprhome;
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
    home.packages = (with pkgs.libsForQt5; [
      kdegraphics-thumbnailers
      dolphin
    ]);

    services.kdeconnect.enable = true;

    xdg.configFile."kdeglobals".text = ''
      [Colors:View]
      BackgroundNormal=#303338
    '';
  };
}



