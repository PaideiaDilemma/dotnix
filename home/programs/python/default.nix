{
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = [
    (pkgs.python312.withPackages (pip: [
      pip.pwntools
      #inputs.los-nixpkgs.packages.${pkgs.system}.pwntools
      pip.colorama
      pip.ipython
      pip.numpy
      pip.pycryptodome
      pip.requests
      pip.scipy
      pip.tqdm
    ]))
  ];
}
