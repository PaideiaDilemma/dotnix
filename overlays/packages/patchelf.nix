{pkgs, ...}:
pkgs.rustPlatform.buildRustPackage {
  name = "patchelfdd";
  version = "latest";

  src = pkgs.fetchFromGitHub {
    owner = "PaideiaDilemma";
    repo = "patchelfdd";
    rev = "2ed0dff420eea063f85c47da286f544981b358bc";
    hash = "sha256-aK6zZNB4gWWCNXhbpKXkYk+8ZWVLbG2npxv+3ei3KbU=";
  };

  cargoHash = "sha256-LQ9PYW36fA2pLO8DJ/0gio9Rcq5wK03Ubvzmy5nxg8U=";

  doCheck = false; # I need to fix the static paths in the tests...
}
