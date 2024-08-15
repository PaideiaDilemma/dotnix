{
  lib,
  stdenv,
  python312,
  swww,
}:
stdenv.mkDerivation {
  name = "hyprsetwallpaper";
  dontUnpack = true;
  buildInputs = [
    (python312.withPackages (ps:
      with ps; [
        pillow
      ]))
  ];
  propagatedBuildInputs = [
    swww
  ];
  installPhase = ''
    install -Dm755 ${./hyprsetwallpaper.py} $out/bin/hyprsetwallpaper
  '';
}
