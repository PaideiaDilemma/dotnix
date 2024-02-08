{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (import ../../overlays/ollama-overlay.nix)
  ];

  users.groups.render.members = [ "max" ];
}
