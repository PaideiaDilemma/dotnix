final: prev: rec {
  ollama = prev.callPackage ./packages/ollama.nix {};
}
