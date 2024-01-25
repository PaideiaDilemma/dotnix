{ inputs, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hyprhome;
in
{
  options.hyprhome.steam = {
    enable = mkOption {
      default = true;
      description = "Whether to enable steam.";
      type = types.bool;
    };
  };

  config = mkIf (cfg.gui.enable && cfg.steam.enable) {
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
  };
}
