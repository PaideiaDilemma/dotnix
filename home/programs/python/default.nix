{ pkgs, lib, ... }:
{
  home.packages = [
    (pkgs.python311.withPackages (pip: [
      pip.numpy
      pip.requests
      pip.scipy
      pip.pwntools
      pip.pycryptodome
      pip.colorama
    ]))
  ];
}
