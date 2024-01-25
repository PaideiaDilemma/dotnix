{ config, lib, pkgs, ... }:
with lib;
let
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

  sixNames = [
    "red"
    "yellow"
    "green"
    "cyan"
    "blue"
    "magenta"
  ];

  sevenNames = [
    "red"
    "orange"
    "yellow"
    "green"
    "cyan"
    "blue"
    "purple"
  ];

  eightNames = [
    "red"
    "orange"
    "yellow"
    "green"
    "cyan"
    "blue"
    "purple"
    "magenta"
  ];

  mapOptions = options: listToAttrs (
    map
      (name: {
        inherit name;
        value = mkOption {
          type = types.str;
        };
      })
      options);

  removeHash = str: removePrefix "#" str;
in
{
  options.colors = {
    base = mapOptions baseColorNames;
    six = mapOptions sixNames;
    six' = mapOptions sixNames;
    seven = mapOptions sevenNames;
    eight = mapOptions eightNames;

    console = mkOption {
      type = types.listOf types.str;
      default = [
        (removeHash config.colors.base.shade)
        (removeHash config.colors.six.red)
        (removeHash config.colors.six.green)
        (removeHash config.colors.six.yellow)
        (removeHash config.colors.six.blue)
        (removeHash config.colors.six.magenta)
        (removeHash config.colors.six.cyan)
        (removeHash config.colors.base.sun)
        (removeHash config.colors.base.sky_)
        (removeHash config.colors.six'.red)
        (removeHash config.colors.six'.green)
        (removeHash config.colors.six'.yellow)
        (removeHash config.colors.six'.blue)
        (removeHash config.colors.six'.magenta)
        (removeHash config.colors.six'.cyan)
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
        default = config.colors.six.sky_;
      };
      base04 = mkOption {
        type = types.str;
        default = config.colors.six.sky';
      };
      base05 = mkOption {
        type = types.str;
        default = config.colors.six.sun_;
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
        default = config.colors.base.magenta;
      };
    };
  };
}
