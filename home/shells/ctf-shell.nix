# save this as shell.nix
with import <nixpkgs> { };

mkShell {
  packages = [  ];
  NIX_LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
    stdenv.cc.cc
    openssl
    openssl_legacy
    mysql80
    libxcrypt
    libxcrypt-legacy
    libseccomp
    libelf
    glib
    bzip2
    xz.out
  ];
  NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
}
