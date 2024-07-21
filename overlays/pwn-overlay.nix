inputs: final: prev: {
  patchelfdd = inputs.los-nixpkgs.packages.${prev.system}.patchelfdd;
  #pwndbg = inputs.los-nixpkgs.packages.${prev.system}.pwndbg;
  pwntools = inputs.los-nixpkgs.packages.${prev.system}.pwntools;
}
