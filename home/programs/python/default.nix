{
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = [
    (pkgs.python311.withPackages (pip: [
      inputs.los-nixpkgs.packages.${pkgs.system}.pwntools
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
