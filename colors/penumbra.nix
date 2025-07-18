{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.penumbra;
  penumbra = {
    seven = {
      red = "#CA7081";
      orange = "#C27D40";
      yellow = "#92963A";
      green = "#3EA57B";
      cyan = "#00A0BA";
      blue = "#6E8DD5";
      purple = "#AC78BD";
    };

    seven' = {
      red = "#DF7F78";
      orange = "#C27D40"; #same
      yellow = "#9CA748";
      green = "#44B689";
      cyan = "#00B3C2";
      blue = "#7A9BEC"; # same
      purple = "#A48FE1";
    };

    balanced = {
      base = {
        sun' = "#FFFDFB";
        sun = "#FFF7ED";
        sun_ = "#F2E6D4";
        sky' = "#BEBEBE";
        sky = "#8F8F8F";
        sky_ = "#636363";
        shade' = "#3E4044";
        shade = "#303338";
        shade_ = "#24272B";
      };
    };
    contrast' = {
      base = {
        sun' = "#FFFDFB";
        sun = "#FFF7ED";
        sun_ = "#F2E6D4";
        sky' = "#CECECE";
        sky = "#9E9E9E";
        sky_ = "#636363";
        shade' = "#3E4044";
        shade = "#24272B";
        shade_ = "#181B1F";
      };
    };
    contrast'' = {
      base = {
        sun' = "#FFFDFB";
        sun = "#FFF7ED";
        sun_ = "#F2E6D4";
        sky' = "#DEDEDE";
        sky = "#AEAEAE";
        sky_ = "#636363";
        shade' = "#3E4044";
        shade = "#181B1F";
        shade_ = "#0D0F13";
      };
    };
  };

  removeHash = str: (removePrefix "#" str);
in {
  imports = [./default.nix];

  options.penumbra = {
    set = mkOption {
      type = types.enum ["balanced" "contrast'" "contrast''"];
      default = "balanced";
    };
  };

  config.colors = {
    base = penumbra.${cfg.set}.base;
    accent = penumbra.seven;
    accent' = penumbra.seven';
  };
}
