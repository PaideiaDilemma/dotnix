{ pkgs, lib, ... }:
{
  home.packages = [
    (pkgs.python311.withPackages (pip: [
      pip.colorama
      pip.ipython
      pip.numpy
      pip.pwntools
      pip.pycryptodome
      pip.requests
      pip.scipy
      pip.tqdm
    ]))
  ];
}
