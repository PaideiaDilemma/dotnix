{
  lib,
  stdenv,
  python311,
  swww,
}:
stdenv.mkDerivation {
  name = "hyprsetwallpaper";
  dontUnpack = true;
  buildInputs = [
    (python311.withPackages (ps:
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
