{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hyprhome;
  colors = config.colors;
in {
  options.hyprhome.niri = {
    enable = mkOption {
      default = true;
      description = "Whether to enable the niri compositor.";
      type = types.bool;
    };
  };

  config = mkIf (cfg.gui.enable && cfg.niri.enable) {
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
      settings = {
        screenshot-path = "~/media/picture/screenshots/screenshot_%Y-%m-%d_%H-%M-%S.png";
        prefer-no-csd = true;
        spawn-at-startup = [
          {command = ["waybar"];}
          {command = ["swww-daemon"];}
          # TODO: Make this a service
          {command = ["wlsunset" "-l" "48.2" "-L" "16.3" "-t" "4800"];}
          {command = ["wlclipmgr" "watch" "--block" "\"password store sleep:2\""];}
          {command = ["kdeconnect-indicator"];}
          {command = ["nm-applet"];}
        ];

        input = {
          keyboard.xkb = {
            layout = "eu";
            options = "caps:swapescape";
          };

          touchpad = {
            # disable when typing /trackpointing
            dwt = true;
            natural-scroll = true;
            click-method = "clickfinger";
          };

          focus-follows-mouse = true;
          warp-mouse-to-focus = true;
        };

        layout = {
          gaps = 6;
          center-focused-column = "never";
          preset-column-widths = [
            {proportion = 0.333;}
            {proportion = 0.5;}
            {proportion = 0.666;}
          ];
          default-column-width = {proportion = 0.5;};

          focus-ring = {
            enable = true;
            width = 2;
            active.color = colors.base.sun;
            inactive.color = colors.base.sky;
          };
        };

        window-rules = [
          {
            geometry-corner-radius = let
              radius = 6.0;
            in {
              bottom-left = radius;
              bottom-right = radius;
              top-left = radius;
              top-right = radius;
            };
            clip-to-geometry = true;
          }
        ];

        binds = with config.lib.niri.actions; {
          # Launchers
          "Mod+Return".action = spawn "${cfg.terminal}";
          "Mod+Shift+Return".action = spawn "${cfg.terminal}" "ipython";
          "Mod+E".action = spawn "dolphin";
          "Mod+B".action = spawn "chromium";
          "Mod+Shift+L".action = spawn "hyprlock";

          # Rofi menus
          "Mod+D".action = spawn "rofi" "-show" "drun" "-show-icons";
          "Mod+R".action = spawn "rofi" "-show" "run" "-run-shell-command" "'{terminal} zsh -ic \"{cmd} && read\"'";
          "Mod+F".action = spawn "rofi" "-show" "window" "-show-icons";
          "Mod+Shift+P".action = spawn "rofi-pass";
          "Mod+V".action = spawn "wlclipmgr" "restore" "-i" "\"$(wlclipmgr list -l 100 | rofi -dmenu | awk '{print $1}')\"";

          # Notification Control "Ctrl+Escape".action.spawn = "makoctl dismiss";
          "Ctrl+Shift+Escape".action = spawn "makoctl" "dismiss";

          # Screenshots
          "Mod+Shift+S".action = screenshot;
          "Mod+Ctrl+S".action = screenshot-screen;

          # tofi menus
          #$tofi_theme = ~/.config/tofi/top_left
          #"Mod,D,exec,tofi-drun --drun-launch=true --include $tofi_theme"
          #"Mod,R,exec,tofi-run --include $tofi_theme | xargs sh -c"
          #"ModSHIFT,P,exec,$terminal fish -c \"pass clip && sleep 1\""
          #"ModSHIFT,R,exec,wlclipmgr restore -i \"$(wlclipmgr list -l 100 | tofi --include $tofi_theme | awk '{print $1}')\""

          # Window Manager
          "Mod+C".action = close-window;
          "Mod+Shift+C".action = close-window;
          "Mod+Shift+M".action = fullscreen-window;
          "Mod+M".action = maximize-column;

          "Mod+Shift+E".action = quit;

          "Mod+Left".action = focus-column-left;
          "Mod+Right".action = focus-column-right;
          "Mod+Up".action = focus-window-up;
          "Mod+Down".action = focus-window-down;

          "Mod+H".action = focus-column-left;
          "Mod+L".action = focus-column-right;
          "Mod+J".action = focus-window-up;
          "Mod+K".action = focus-window-down;
          "Mod+Shift+0".action = focus-column-first;
          "Mod+Shift+4".action = focus-column-last;

          "Mod+Q".action = focus-workspace-up;
          "Mod+W".action = focus-workspace-down;

          "Mod+1".action = focus-workspace "1";
          "Mod+2".action = focus-workspace "2";
          "Mod+3".action = focus-workspace "3";
          "Mod+4".action = focus-workspace "4";
          "Mod+5".action = focus-workspace "5";
          "Mod+6".action = focus-workspace "6";
          "Mod+7".action = focus-workspace "7";
          "Mod+8".action = focus-workspace "8";
          "Mod+9".action = focus-workspace "9";

          "Alt+Q".action = move-window-to-workspace-up;
          "Alt+W".action = move-window-to-workspace-down;

          "Alt+1".action = move-window-to-workspace "1";
          "Alt+2".action = move-window-to-workspace "2";
          "Alt+3".action = move-window-to-workspace "3";
          "Alt+4".action = move-window-to-workspace "4";
          "Alt+5".action = move-window-to-workspace "5";
          "Alt+6".action = move-window-to-workspace "6";
          "Alt+7".action = move-window-to-workspace "7";
          "Alt+8".action = move-window-to-workspace "8";
          "Alt+9".action = move-window-to-workspace "9";

          "Mod+period".action = consume-window-into-column;
          "Mod+comma".action = expel-window-from-column;

          "XF86MonBrightnessUp".action = spawn "brightnessctl" "set" "+5%";
          "XF86MonBrightnessDown".action = spawn "brightnessctl" "set" "5%-";
        };
      };
    };
  };
}
