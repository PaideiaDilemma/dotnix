{ inputs, pkgs, ... }:
{
  nixpkgs.overlays = [
    (_: prev: {
      steam = prev.steam.override {
        extraProfile = "export STEAM_EXTRA_COMPAT_TOOLS_PATHS='${inputs.nix-gaming.packages.${pkgs.system}.proton-ge}'";
      };
    })
  ];

  home.packages = (with pkgs; [
    steam
  ]);
}
