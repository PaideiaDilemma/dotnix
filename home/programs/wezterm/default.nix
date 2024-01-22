{ config, pkgs, inputs, ... }:
{
  programs.wezterm = {
    enable = true;
    package = inputs.wezterm.packages.${pkgs.system}.default;
    enableZshIntegration = true;
    colorSchemes.penumbra = {
      background = "#303338";
      foreground = "#FFF7ED";
      cursor_bg = "#FFF7ED";
      cursor_border = "#FFF7ED";
      cursor_fg = "#24272B";
      selection_bg = "#3E4044";
      ansi = [
        "#303338"
        "#DF7C8E"
        "#44B689"
        "#A1A641"
        "#7A9BEC"
        "#BE85D1"
        "#00B1CE"
        "#F2E6D4"
      ];

      brights = [
        "#636363"
        "#F18AA1"
        "#58C792"
        "#B4B44A"
        "#83ADFF"
        "#CC94E6"
        "#16C3DD"
        "#FFFDFB"
      ];
    };
    extraConfig = ''
      local wezterm = require("wezterm")
      local function font_with_fallback(name, params)
        local names = { name, "Font Awesome", "Hack Nerd Font Mono" }
        return wezterm.font_with_fallback(names, params)
      end

      local font_name = "Fira Code"
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
}
