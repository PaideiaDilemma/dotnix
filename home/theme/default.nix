{ config, lib, pkgs, ... }:

let
  themes = pkgs.callPackage ./oomox.nix { };
in
{
  imports = [
    ./qtct.nix
    #./kvantum.nix
  ];

  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 16;
  };

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
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };

  qt = {
    enable = true;
    platformTheme = "qtct";
    #style.name = "kvantum";
  };
}
