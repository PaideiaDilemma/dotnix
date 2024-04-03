# save this as shell.nix
with import <nixpkgs> {};
  mkShell {
    packages = [pkgs.clang-tools pkgs.clangStdenv];
    NIX_LD_LIBRARY_PATH = with pkgs;
      lib.makeLibraryPath [
        bzip2
        glib
        libelf
        libseccomp
        libxcrypt
        libxcrypt-legacy
        mysql80
        openssl
        openssl_legacy
        stdenv.cc.cc
        xz.out
      ];
    NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
  }
