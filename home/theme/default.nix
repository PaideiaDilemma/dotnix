{ inputs, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hyprhome;
  themes = pkgs.callPackage ./oomox.nix { colors = config.colors; };
in
{
  imports = [
    ./qtct.nix
    #./kvantum.nix
  ];

  config = mkIf (cfg.gui.enable) {
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "PearWhiteCursors";
      package = pkgs.pearWhiteCursors;
      size = 16;
    };

    home.packages = [pkgs.pearWhiteCursors];

    gtk = {
      enable = true;
      iconTheme = {
        name = "Penumbra";
        package = themes.penumbra-oomox-icons;
      };

      theme = {
        name = "Penumbra";
        package = themes.penumbra-oomox-gtk;
      };

      cursorTheme = {
        name = "PearWhiteCursors";
        package = pkgs.pearWhiteCursors;
      };
    };

    qt = {
      enable = true;
      platformTheme = "qtct";
      #style.name = "kvantum";
    };
  };
}
