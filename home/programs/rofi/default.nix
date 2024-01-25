{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hyprhome;
in
{
  options.hyprhome.rofi = {
    enable = mkOption {
      default = true;
      description = "Whether to enable rofi.";
      type = types.bool;
    };
  };

  config = mkIf (cfg.gui.enable && cfg.rofi.enable) {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      configPath = "${config.xdg.configHome}/rofi/config.rasi";
    };

    xdg.configFile."rofi/config.rasi".text = ''
      /*
       * Colors Penumbar Balanced
       * ~ https://github.com/nealmckee/penumbra/blob/main/penumbra.tsv
       */

      configuration {
          font: "Noto Sans 12";
          display-drun: "Apps ";
          terminal: "wezterm";
          seperator: false;
      }

      * {
          bg:         #636363CC;
          red:        #CB7459;
          green:      #46A473;
          yellow:     #A38F2D;
          blue:       #7E87D6;
          purple:     #BD72A8;
          cyan:       #00A0BE;
          emphasis:   #00A0BE;
          text:       #FFF7ED;
          text-alt:   #F2E6D4;
          fg:         #FFF7ED;
          bg-alt:     #636363;
          gray:       #8F8F8F;
          lightgray:  #BEBEBE;

          spacing: 5;

          text-color: @text;
      }

      window {
          x-offset: 5px;
          y-offset: 5px;
          width: 25%;
          background-color: @bg;
          border: 1;
          border-color: @fg;
          border-radius: 9;
          padding: 5;
      }

      mainbox {
      }

      inputbar {
          margin: 0px 0px 4px 0px;
          children: [prompt, textbox-prompt-colon, entry, case-indicator];
      }

      prompt {
          text-color: @cyan;
      }

      textbox-prompt-colon {
          expand: false;
          str: " :";
          text-color: @text-alt;
      }

      entry {
          text-color: @text;
          margin: 0px 10px;
      }

      listview {
          spacing: 0px;
          dynamic: true;
          scrollbar: false;
          columns: 1;
          fixed-height: true;
          lines: 15;
      }

      #element {
          padding: 5px;
          border-radius: 8px;
      }
      #element.normal.normal {
          background-color: transparent;
          text-color:       @fg;
      }
      #element.normal.urgent {
          background-color: transparent;
          text-color:       @red;
      }
      #element.normal.active {
          background-color: @bg;
          text-color:       @cyan;
      }
      #element.selected.normal {
          background-color: @bg-alt;
          text-color:       @fg;
          border: 1px;
          border-color: @fg;
      }
      #element.selected.urgent {
          background-color: @bg;
          text-color:       @red;
          border: 1px;
          border-color: @fg;
      }
      #element.selected.active {
          background-color: @bg;
          text-color:       @cyan;
          border-color: @cyan;
          border: 1px;
          border-color: @fg;
      }
      #element.alternate.normal {
          background-color: transparent;
          text-color:       @fg;
      }
      #element.alternate.urgent {
          background-color: transparent;
          text-color:       @red;
      }
      #element.alternate.active {
          background-color: transparent;
          text-color:       @cyan;
      }

      message {
        padding: 5px;
        border-radius: 3px;
        background-color: @emphasis;
        border: 1px;
        border-color: @cyan;
      }

      button selected {
        padding: 5px;
        border-radius: 3px;
        background-color: @emphasis;
      }
    '';
  };
}
