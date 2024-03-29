{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hyprhome;
in {
  options.hyprhome.direnvs = {
    enable = mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to link direnvs";
    };
  };

  config = mkIf cfg.direnvs.enable {
    home.file."CTF/shell.nix".source = ./ctf-shell.nix;
  };
}
