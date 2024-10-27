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
    ./qtct.nix
    #./kvantum.nix
  ];

  config = mkIf (cfg.gui.enable) {
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "DeepinV20XCursors";
      package = pkgs.deepinV20XCursors;
      size = 16;
    };

    gtk = let
      themes = pkgs.callPackage ./oomox.nix {colors = config.colors;};
    in {
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
        name = "DeepinV20XCursors";
        package = pkgs.deepinV20XCursors;
      };
    };

    qt = {
      enable = true;
      # instead handled below
      platformTheme.name = null;
      #style.name = "kvantum";
    };

    home.packages = [pkgs.deepinV20XCursors pkgs.libsForQt5.qt5ct pkgs.qt6ct];
    home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";
  };
}
