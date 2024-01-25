{ inputs, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.hyprhome;
  colors = config.colors;
in
{
  options.hyprhome.wezterm = {
    enable = mkOption {
      default = true;
      description = "Whether to enable the wezterm";
      type = types.bool;
    };
  };

  config = mkIf (cfg.gui.enable && cfg.wezterm.enable) {
    programs.wezterm = {
      enable = true;
      enableZshIntegration = false;
      enableBashIntegration = false;
      package = inputs.wezterm.packages.${pkgs.system}.default;
      colorSchemes.penumbra = {
        background = colors.base.shade;
        foreground = colors.base.sun;
        cursor_bg = colors.base.sun;
        cursor_border = colors.base.sun;
        cursor_fg = colors.base.shade_;
        selection_bg = colors.base.shade';
        ansi = [
          colors.base.shade
          colors.six.red
          colors.six.green
          colors.six.yellow
          colors.six.blue
          colors.six.magenta
          colors.six.cyan
          colors.base.sun
        ];

        brights = [
          colors.base.sky_
          colors.six'.red
          colors.six'.green
          colors.six'.yellow
          colors.six'.blue
          colors.six'.magenta
          colors.six'.cyan
          colors.base.sun'
        ];
      };
      extraConfig = ''
        local wezterm = require("wezterm")
        local function font_with_fallback(name, params)
          local names = { name, "Font Awesome 6 Free", "Hack Nerd Font Mono" }
          return wezterm.font_with_fallback(names, params)
        end

        local font_name = "FiraCode Nerd Font"
        return {
          ssh_domains = {
            {
              name = "laptop",
              remote_address = "192.168.1.202",
              username = "max",
            },
          },
          color_scheme = "penumbra",
          font = font_with_fallback(font_name),
          font_size = 13.0,
          font_rules = {
            {
              italic = true,
              font = font_with_fallback(font_name, { italic = true }),
            },
            {
              italic = true,
              intensity = "Bold",
              font = font_with_fallback(font_name, { bold = true, italic = true }),
            },
            {
              intensity = "Bold",
              font = font_with_fallback(font_name, { bold = true }),
            },
            {
              intensity = "Half",
              font = font_with_fallback(font_name, { weight = "Light" }),
            },
          },
          cell_width = 0.9,
          enable_tab_bar = true,
          hide_tab_bar_if_only_one_tab = true,
          show_tab_index_in_tab_bar = false,
          tab_bar_at_bottom = false,
          automatically_reload_config = true,
          inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
          window_decorations = "NONE",
          exit_behavior = "Close",
          bold_brightens_ansi_colors = false,
          default_cursor_style = "SteadyBlock",
          keys = {
            {
              key = "x",
              mods = "CTRL",
              action = "ActivateCopyMode",
            },
            {
              key = "v",
              mods = "CTRL|SHIFT",
              action = wezterm.action({ PasteFrom = "Clipboard" }),
            },
            {
              key = "c",
              mods = "CTRL|SHIFT",
              action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }),
            },
          },
        }
      '';
    };
  };
}
