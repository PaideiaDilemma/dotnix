final: prev: {
  # This is just here for me to do some testing, because my dad's image preview does
  # not work for bigTiffs in dolphin.
  kdePackages = prev.kdePackages.overrideScope (self: super: rec {
    qtimageformats = super.qtimageformats.overrideAttrs (oldAttrs: {
      buildInputs = [prev.libwebp prev.jasper prev.libmng (prev.callPackage ./packages/libtiff.nix {})];
    });
    dolphin = super.dolphin.overrideAttrs (oldAttrs: {
      propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [qtimageformats];
    });
  });
}
