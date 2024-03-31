inputs: final: prev: {
  pwndbg = inputs.los-nixpkgs.packages.${prev.system}.pwndbg;
  pwntools = inputs.los-nixpkgs.packages.${prev.system}.pwntools;
}
