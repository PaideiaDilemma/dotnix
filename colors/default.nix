{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  baseColorNames = [
    "sun'"
    "sun"
    "sun_"
    "sky'"
    "sky"
    "sky_"
    "shade'"
    "shade"
    "shade_"
  ];

  accentColorNames = [
    "red"
    "orange"
    "yellow"
    "green"
    "cyan"
    "blue"
    "purple"
  ];

  mapOptions = options:
    listToAttrs (
      map
      (name: {
        inherit name;
        value = mkOption {
          type = types.str;
        };
      })
      options
    );

  removeHash = str: removePrefix "#" str;
in {
  options.colors = {
    base = mapOptions baseColorNames;
    accent = mapOptions accentColorNames;
    accent' = mapOptions accentColorNames;

    console = mkOption {
      type = types.listOf types.str;
      default = [
        (removeHash config.colors.base.shade)
        (removeHash config.colors.accent.red)
        (removeHash config.colors.accent.green)
        (removeHash config.colors.accent.yellow)
        (removeHash config.colors.accent.blue)
        (removeHash config.colors.accent.orange)
        (removeHash config.colors.accent.cyan)
        (removeHash config.colors.base.sun)
        (removeHash config.colors.base.sky_)
        (removeHash config.colors.accent'.red)
        (removeHash config.colors.accent'.green)
        (removeHash config.colors.accent'.yellow)
        (removeHash config.colors.accent'.blue)
        (removeHash config.colors.accent'.orange)
        (removeHash config.colors.accent'.cyan)
        (removeHash config.colors.base.sun')
      ];
    };

    base16 = {
      base00 = mkOption {
        type = types.str;
        default = config.colors.base.shade_;
      };
      base01 = mkOption {
        type = types.str;
        default = config.colors.base.shade;
      };
      base02 = mkOption {
        type = types.str;
        default = config.colors.base.shade';
      };
      base03 = mkOption {
        type = types.str;
        default = config.colors.accent.sky_;
      };
      base04 = mkOption {
        type = types.str;
        default = config.colors.accent.sky';
      };
      base05 = mkOption {
        type = types.str;
        default = config.colors.accent.sun_;
      };
      base06 = mkOption {
        type = types.str;
        default = config.colors.base.sun;
      };
      base07 = mkOption {
        type = types.str;
        default = config.colors.base.sun';
      };
      base08 = mkOption {
        type = types.str;
        default = config.colors.eight.red;
      };
      base09 = mkOption {
        type = types.str;
        default = config.colors.eight.orange;
      };
      base0A = mkOption {
        type = types.str;
        default = config.colors.eight.yellow;
      };
      base0B = mkOption {
        type = types.str;
        default = config.colors.eight.green;
      };
      base0C = mkOption {
        type = types.str;
        default = config.colors.eight.cyan;
      };
      base0D = mkOption {
        type = types.str;
        default = config.colors.eight.blue;
      };
      base0E = mkOption {
        type = types.str;
        default = config.colors.eight.purple;
      };
      base0F = mkOption {
        type = types.str;
        default = config.colors.base.orange;
      };
    };
  };
}
