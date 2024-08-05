{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hyprhome;
  themes = pkgs.callPackage ./oomox.nix {colors = config.colors;};
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

    home.packages = [pkgs.deepinV20XCursors];

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
        name = "DeepinV20XCursors";
        package = pkgs.deepinV20XCursors;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "qtct";
      #style.name = "kvantum";
    };
  };
}
