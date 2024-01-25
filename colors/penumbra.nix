{ config, lib, ... }:
with lib;
let
  cfg = config.penumbra;
  penumbra = {
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
      six = {
        red = "#CB7459";
        yellow = "#A38F2D";
        green = "#46A473";
        cyan = "#00A0BE";
        blue = "#7E87D6";
        magenta = "#BD72A8";
      };
      seven = {
        red = "#CA7081";
        orange = "#C27D40";
        yellow = "#92963A";
        green = "#3EA57B";
        cyan = "#00A0BA";
        blue = "#6E8DD5";
        purple = "#AC78BD";
      };
      eight = {
        red = "#CA736C";
        orange = "#BA823A";
        yellow = "#8D9741";
        green = "#47A477";
        cyan = "#00A2AF";
        blue = "#5794D0";
        purple = "#9481CC";
        magenta = "#BC73A4";
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
      six = {
        red = "#E18163";
        yellow = "#B49E33";
        green = "#4EB67F";
        cyan = "#00B0D2";
        blue = "#8C96EC";
        magenta = "#D07EBA";
      };
      seven = {
        red = "#DF7C8E";
        orange = "#D68B47";
        yellow = "#A1A641";
        green = "#44B689";
        cyan = "#00B1CE";
        blue = "#7A9BEC";
        purple = "#BE85D1";
      };
      eight = {
        red = "#DF7F78";
        orange = "#CE9042";
        yellow = "#9CA748";
        green = "#50B584";
        cyan = "#00B3C2";
        blue = "#61A3E6";
        purple = "#A48FE1";
        magenta = "#D080B6";
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
      six = {
        red = "#F48E74";
        yellow = "#C7AD40";
        green = "#61C68A";
        cyan = "#1AC2E1";
        blue = "#97A6FF";
        magenta = "#E18DCE";
      };
      seven = {
        red = "#F18AA1";
        orange = "#EA9856";
        yellow = "#B4B44A";
        green = "#58C792";
        cyan = "#16C3DD";
        blue = "#83ADFF";
        purple = "#CC94E6";
      };
      eight = {
        red = "#F58C81";
        orange = "#E09F47";
        yellow = "#A9B852";
        green = "#54C794";
        cyan = "#00C4D7";
        blue = "#6EB2FD";
        purple = "#B69CF6";
        magenta = "#E58CC5";
      };
    };
  };

  removeHash = str: (removePrefix "#" str);
in
{
  imports = [ ./default.nix ];

  options.penumbra = {
    set = mkOption {
      type = types.enum [ "balanced" "contrast'" "contrast''" ];
      default = "balanced";
    };
  };

  config.colors = {
    base = penumbra.${cfg.set}.base;
    six = penumbra.${cfg.set}.six;
    six' = penumbra.contrast''.six;
    seven = penumbra.${cfg.set}.seven;
    eight = penumbra.${cfg.set}.eight;
  };
}
