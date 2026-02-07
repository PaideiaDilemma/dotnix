{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.dotnix;
in {
  options.dotnix = {
    boot.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable boot services?";
    };

    gui.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable GUI?";
    };

    username = mkOption {
      default = "max";
      description = "The user name";
      type = types.str;
    };

    fullName = mkOption {
      default = "Maximilian Seidler";
      description = "Full name";
      type = types.str;
    };

    email = mkOption {
      default = "maximilian.seidler@soundwork.at";
      description = "Email address";
      type = types.str;
    };

    terminal = mkOption {
      default = "foot";
      description = "Default terminal emulator";
      type = types.enum ["foot" "footclient"];
    };

    steam.enable = mkOption {
      type = types.bool;
      default = cfg.gui.enable;
      description = "Whether to enable Steam";
    };

    keyMap = mkOption {
      type = types.str;
      default = "eu";
      description = "Console keymap";
    };

    dotfileLocation = mkOption {
      type = types.str;
      default = "\${HOME}/nixos-dotfiles";
      description = "Location of the dotfiles flake";
    };
  };
}
