{ config, lib, pkgs, ... }:

let
  hyprsetwallpaper = pkgs.stdenv.mkDerivation {
    name = "hyprsetwallpaper";
    unpackPhase = ":";
    buildInputs = [
      (pkgs.python3.withPackages (ps: with ps; [
        pillow
      ]))
    ];
    installPhase = ''
      install -Dm755 ${./hyprsetwallpaper.py} $out/bin/hyprsetwallpaper
    '';
  };

  cava-internal = pkgs.writeShellScriptBin "cava-internal" ''
    cava -p ~/.config/cava/config1 | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g;'
  '';
in
{
  home.packages = with pkgs; [
    hyprsetwallpaper
    cava-internal
  ];
}

