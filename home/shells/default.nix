{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotnix;
in {
  options.dotnix.direnvs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to link direnvs";
    };
  };

  config = lib.mkIf cfg.direnvs.enable {
    home.file."CTF/shell.nix".source = ./ctf-shell.nix;
  };
}
