final: prev: {
  kdePackages = prev.kdePackages.overrideScope' (self: super: {
    qtimageformats = super.qtimageformats.overrideAttrs (oldAttrs: {
      buildInputs = [ prev.libwebp prev.jasper prev.libmng ( prev.callPackage ./packages/libtiff.nix {} )];
    });
  });
}
