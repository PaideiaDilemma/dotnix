{ pkgs, ... }:
{
  nixpkgs.overlays = [
    #(import ../../overlays/ollama-amdgpu-overlay.nix)
  ];

  users.groups.render.members = [ "max" ];
}
