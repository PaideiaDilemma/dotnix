final: prev: {
  curlMinimal8_14_1 = prev.curlMinimal.overrideAttrs rec {
    version = "8.14.1";
    src = prev.fetchurl {
      urls = [
        "https://curl.haxx.se/download/curl-${version}.tar.xz"
        "https://github.com/curl/curl/releases/download/curl-${
          builtins.replaceStrings ["."] ["_"] version
        }/curl-${version}.tar.xz"
      ];
      hash = "sha256-9GGaHiR0xLv+3IinwhkSCcgzS0j6H05T/VhMwS6RIN0=";
    };
  };
  cmake3 =
    (prev.cmake.override {
      curlMinimal = final.curlMinimal8_14_1;
    }).overrideAttrs (old: rec {
      patches = [
        # Add NIXPKGS_CMAKE_PREFIX_PATH to cmake which is like CMAKE_PREFIX_PATH
        # except it is not searched for programs
        ./cmake-compat-patches/000-nixpkgs-cmake-prefix-path.diff
        # Don't search in non-Nix locations such as /usr, but do search in our libc.
        ./cmake-compat-patches/001-search-path.diff
        # Backport of https://gitlab.kitware.com/cmake/cmake/-/merge_requests/9900
        # Needed to correctly link curl in pkgsStatic.
        ./cmake-compat-patches/008-FindCURL-Add-more-target-properties-from-pkg-config.diff
        # Backport of https://gitlab.kitware.com/cmake/cmake/-/commit/1b0c92a3a1b782ff3e1c4499b6ab8db614d45bcd
        ./cmake-compat-patches/009-cmCurl-Avoid-using-undocumented-type-for-CURLOPT_NETRC-values.diff
      ];
      version = "3.31.6";

      src = prev.fetchurl {
        url = "https://cmake.org/files/v${prev.lib.versions.majorMinor version}/cmake-${version}.tar.gz";
        hash = "sha256-ZTQn8PUBR1Cq//InJ/sqpgxscyypGAjPt4ziLd2eVfA=";
      };
    });
  keystone = prev.keystone.override {
    cmake = final.cmake3;
  };
  catimg = prev.catimg.overrideAttrs (old: {
    cmakeFlags =
      old.cmakeFlags or []
      ++ prev.lib.mapAttrsToList prev.lib.cmakeFeature {
        CMAKE_POLICY_VERSION_MINIMUM = "3.5";
      };
  });
}
