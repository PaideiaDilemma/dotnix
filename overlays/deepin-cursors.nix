_final: prev: let
  deepinV20CursorSource = prev.fetchFromGitHub {
    owner = "PaideiaDilemma";
    repo = "DeepinV20-white-cursors";
    rev = "master";
    hash = "sha256-/8+Bkw2gpwlMwnrv0v2L9olpNbZ2HutiILjW8Xko1XA=";
  };
in {
  deepinV20XCursors = prev.callPackage prev.pkgs.stdenv.mkDerivation {
    name = "DeepinV20XCursors";
    src = deepinV20CursorSource;
    installPhase = ''
      mkdir -p $out/share/icons
      cp -r $src/dist $out/share/icons/DeepinV20XCursors
    '';
  };

  deepinV20HyprCursors = prev.callPackage prev.pkgs.stdenv.mkDerivation {
    name = "DeepinV20HyprCursors";
    src = deepinV20CursorSource;
    installPhase = ''
      mkdir -p $out/share/icons
      cp -r $src/dist_hyprcursor $out/share/icons/DeepinV20HyprCursors
    '';
  };
}
