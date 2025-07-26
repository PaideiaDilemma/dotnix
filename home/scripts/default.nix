{
  config,
  lib,
  pkgs,
  ...
}: let
  hyprsetwallpaper = pkgs.stdenv.mkDerivation {
    name = "hyprsetwallpaper";
    dontUnpack = true;
    buildInputs = [
      (pkgs.python3.withPackages (ps:
        with ps; [
          pillow
        ]))
    ];
    installPhase = ''
      install -Dm755 ${./hyprsetwallpaper.py} $out/bin/hyprsetwallpaper
    '';
  };

  # I use this for disrobox
  remove-nix-from-path = pkgs.writeShellScriptBin "remove-nix-from-path" ''
    export PATH=$(echo $PATH | sed -e 's|/nix/[^:]*||g')
  '';
in {
  home.packages = with pkgs; [
    hyprsetwallpaper
    remove-nix-from-path
  ];
}
