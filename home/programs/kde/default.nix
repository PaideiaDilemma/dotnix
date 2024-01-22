{ pkgs, lib, ... }:
{
  home.packages = with pkgs.libsForQt5; [
    kdegraphics-thumbnailers
    dolphin
  ];

  services.kdeconnect.enable = true;

  xdg.configFile."kdeglobals".text = ''
    [Colors:View]
    BackgroundNormal=#303338
  '';
}



