_final: prev: {
  pearWhiteCursors = prev.callPackage prev.pkgs.stdenv.mkDerivation {
    name = "PearWhiteCursors";
    src = ./PearWhiteCursors.tar.gz;
    installPhase = ''
      mkdir -p $out/share/icons/default
      cp -r . $out/share/icons/default
    '';
  };
}
