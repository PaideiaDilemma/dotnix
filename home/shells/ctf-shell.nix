# save this as shell.nix
with import <nixpkgs> { };

mkShell {
  packages = [  ];
  NIX_LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
    stdenv.cc.cc
    openssl
    libseccomp
    libelf
    glib
    bzip2
  ];
  NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
}
