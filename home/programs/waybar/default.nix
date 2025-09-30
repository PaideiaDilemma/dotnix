{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hyprhome;
  colors = config.colors;
  theme_switch = pkgs.writeShellScriptBin "light-dark-theme-switch" ''
    STATE_FILE=$XDG_STATE_HOME/.dark_or_light_mode_toggle
    FOOT_INITIAL_FILE=$XDG_CONFIG_HOME/foot/initial_color_theme.ini
    STATE_LIGHT="{\"text\": \"\", \"class\": \"light\"}"
    STATE_DARK="{\"text\": \"\", \"class\": \"dark\"}"
    STATE_BUG="{\"text\": \"\", \"class\": \"light\"}"

    if [ ! -e $FOOT_INITIAL_FILE ]; then
      touch $FOOT_INITIAL_FILE
    fi

    if [ ! -e $STATE_FILE ]; then
      echo "1" > $STATE_FILE
      echo $STATE_DARK
      exit 0
    fi

    while IFS= read -r line; do
      case "$line" in
        1)
          if [ "$1" = "get" ]; then
            echo $STATE_DARK
            exit 0
          fi

          echo $STATE_LIGHT
          pkill -USR2 foot
          echo "2" > $STATE_FILE
          echo "initial-color-theme=2" > $FOOT_INITIAL_FILE
          exit 1
          ;;
        2)
          if [ "$1" = "get" ]; then
            echo $STATE_LIGHT
            exit 0
          fi

          echo $STATE_DARK
          pkill -USR1 foot
          echo "1" > $STATE_FILE
          echo "initial-color-theme=1" > $FOOT_INITIAL_FILE
          exit 0
          ;;
        *)
          echo $STATE_BUG
          exit 1337
          ;;
      esac
    done < $STATE_FILE
  '';
in {
  options.hyprhome.waybar = {
    enable = mkOption {
      default = true;
      description = "Whether to enable waybar.";
      type = types.bool;
    };

    terminal = mkOption {
      default = cfg.terminal;
      description = "The terminal to use.";
      type = types.str;
    };

    output = mkOption {
      default = cfg.gui.primaryMonitor;
      description = "Waybar output monitors.";
      type = types.str;
    };

    battery.enable = mkOption {
      default = false;
      description = "Whether to enable the battery module.";
      type = types.bool;
    };
  };

  config = mkIf (cfg.gui.enable && cfg.waybar.enable) {
    home.packages = with pkgs; [
      playerctl
      pavucontrol
    ];

    programs.waybar = {
      enable = true;
      systemd = {
        enable = false;
        #target = "graphical-session.target";
      };
      settings = [
        {
          "output" = "${
            if (cfg.waybar.output != "")
            then cfg.waybar.output
            else "*"
          }";
          "layer" = "top"; # Waybar at top layer
          # "position" = "left"; # Waybar position (top|bottom|left|right)
          "height" = 27; # Waybar height (to be removed for auto height)
          #"gtk-layer-shell" = true;
          "spacing" = 2;
          # Choose the order of the modules
          "modules-left" = [
            "privacy"
            "idle_inhibitor"
            "custom/theme"
            "custom/separator"
            "hyprland/workspaces"
            "custom/separator"
            "hyprland/submap"
            "hyprland/window"
          ];
          # "modules-center" = [];
          "modules-right" = [
            "custom/separator"
            "custom/playerctl"
            "custom/separator"
            "systemd-failed-units"
            "cpu"
            "temperature#cpu"
            "memory"
            (
              if cfg.waybar.battery.enable
              then "battery"
              else ""
            )
            "pulseaudio"
            "network"
            # "custom/separator"
            # "custom/waylandvsxorg"
            "clock"
            "custom/separator"
            "tray"
          ];
          # Modules configuration
          "hyprland/window" = {
            "format" = "{}";
            "all-outputs" = true;
          };
          "hyprland/workspaces" = {
            "format" = "{name}";
            "tooltip-format" = "{title}";
            "all-outputs" = true;
            "sort-by-name" = false;
            "on-click" = "activate";
            "on-click-middle" = "close";
            "sort-by-coordinates" = true;
            "active-only" = false;
            "show-special" = true;
          };
          "hyprland/submap" = {
            "format" = "󰘴 {} ";
            "tooltip" = false;
          };
          "custom/separator" = {
            "format" = "|";
            "interval" = "once";
            "tooltip" = false;
          };
          "idle_inhibitor" = {
            "format" = "{icon}";
            "format-icons" = {
              "activated" = "";
              "deactivated" = "";
            };
          };
          "custom/theme" = {
            "interval" = "once";
            "return-type" = "json";
            "exec" = "${lib.getExe theme_switch} get";
            "on-click" = "${lib.getExe theme_switch}";
            "format" = "{}";
          };
          "tray" = {
            "icon-size" = 24;
            "spacing" = 6;
          };
          "clock" = {
            # "timezone" = "America/New_York";
            # "format" = " {time}";
            "format" = "{:%d.%m.%Y %H:%M}";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            "format-alt" = "{:%H:%M:%S}";
            "interval" = 1;
          };
          "cpu" = {
            "format" = " {usage}%";
            "on-click" = ''${cfg.waybar.terminal} btop'';
          };
          "memory" = {
            "format" = " {}%";
          };
          "temperature#cpu" = {
            "hwmon-path" = "/sys/class/hwmon/hwmon0/temp1_input";
            "critical-threshold" = 80;
            # "format-critical" = "{temperatureC}°C {icon}";
            "format" = "<small><span style=\"italic\">CPU {icon}</span></small> {temperatureC}°C";
            "format-icons" = ["" "" "" "" ""];
            "interval" = 3;
          };
          "backlight" = {
            # "device" = "acpi_video1";
            "format" = "{icon} {percent}%";
            "format-icons" = ["" ""];
          };
          "battery" = {
            "bat" = "BAT0";
            "interval" = 30;
            "states" = {
              "full" = 100;
              "good" = 95;
              "ok" = 65;
              "warning" = 40;
              "critical" = 15;
            };
            "tooltip-format" = "{timeTo} [Power draw rn: {power}W]";
            "format" = "{icon} {capacity}%";
            "format-charging-full" = "󰂅 {capacity}%";
            "format-charging-good" = "󰢞 {capacity}%";
            "format-charging-ok" = "󰢝 {capacity}%";
            "format-charging-warning" = "󰂆 {capacity}%";
            "format-charging-critical" = "󰢟 {capacity}%";
            "format-icons" = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            "format-icons-charge" = ["󰢟" "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰢝" "󰂉" "󰢞" "󰂊" "󰂅"];
          };
          "battery#bat2" = {
            "bat" = "BAT2";
          };
          "network" = {
            # "interface" = "wlp2*"; # (Optional) To force the use of this interface
            "format-wifi" = "{icon} {essid} ({signalStrength}%)";
            "format-icons" = ["󰤟" "󰤢" "󰤥" "󰤨"];
            "format-ethernet" = "󰈀 {ipaddr}/{cidr}";
            "format-linked" = " {ifname} (No IP)";
            "format-disconnected" = "󰤮 Disconnected";
            "format-alt" = "{ifname}: {ipaddr}/{cidr}";
          };
          "systemd-failed-units" = {
            "tooltip-format" = "Displays number of systemd units or ok";
            "format" = "✗ (system: {nr_failed_system}, user: {nr_failed_user}";
            "format-ok" = "✓";
            "hide-on-ok" = false;
            "system" = true;
            "user" = true;
          };
          "privacy" = {
            "icon-spacing" = 6;
            "icon-size" = 16;
            "modules" = [
              {
                "type" = "screenshare";
                "tooltip" = true;
                "tooltip-icon-se" = 24;
              }
              {
                "type" = "audio-in";
                "tooltip" = true;
                "tooltip-icon-size" = 24;
              }
            ];
          };
          "pulseaudio" = {
            # "scroll-step": 1, // %, can be a float
            "format" = "{icon} {volume}% {format_source}";
            "format-bluetooth" = "󰥰 {volume}% {format_source}";
            "format-bluetooth-muted" = "󰗿 {volume}% {format_source}";
            "format-muted" = "󰝟 {volume}% {format_source}";
            "format-source" = " {volume}%";
            "format-source-muted" = "";
            "format-icons" = {
              "headphone" = "󰋋";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = ["󰕿" "󰖀" "󰕾"];
            };
            "on-click" = "pavucontrol";
          };
          "custom/playerctl" = {
            "exec" = "playerctl metadata --format '{{ artist }} - {{ title }}' 2> /dev/null || true";
            "interval" = 1;
            "format" = " {}";
            "on-click" = "playerctl  play-pause";
            "on-scroll-up" = "playerctl  next";
            "on-scroll-down" = "playerctl previous";
          };
        }
      ];

      style = ''
        @define-color critical ${colors.accent.red}; /* critical color */
        @define-color warning ${colors.accent.yellow};  /* warning color */
        @define-color fgcolor ${colors.base.sun};  /* foreground color */
        @define-color bgcolor rgba(99, 99, 99, 0.8);  /* background color */
        @define-color alert   ${colors.accent.orange};

        @define-color accent1 ${colors.accent.red};
        @define-color accent2 ${colors.accent.yellow};
        @define-color accent3 ${colors.accent.green};
        @define-color accent4 ${colors.accent.cyan};
        @define-color accent5 ${colors.accent.blue};
        @define-color accent6 ${colors.accent.purple};
        @define-color gray ${colors.base.sky};
        @define-color sky_p ${colors.base.sky'};
        @define-color sun_m ${colors.base.sun_};
        @define-color bgmodule @bgcolor;

        * {
            border: none;
            /* `otf-font-awesome` is required to be installed for icons */
            font-family: "FiraCode Nerd Font", "Font Awesome 6 Free";
            /* Recommended font sizes: 720p: ~14px, 1080p: ~18px */
            font-size: 15px;
            min-height: 0px;
            border-radius: 5px;
        }

        /* icons start at U+E900 in Jetbrains mono in gucharmap */

        window#waybar {
          padding: 10px 0px 0px;
          background-color: rgba(99, 99, 99	, 0.63);
          color: @fgcolor;
          transition-property: background-color;
          transition-duration: .5s;
          border-radius: 0px;
        }

        window#waybar.hidden {
          opacity: 0.2;
        }

        /*window#waybar.empty {
            background-color: rgba(99, 99, 99	, 0.30);
        }
        window#waybar.solo {
            background-color: #FFFFFF;
        }*/

        window#waybar.termite {
          background-color: #3F3F3F;
        }

        window#waybar.chromium {
          background-color: #000000;
          border: none;
        }

        #workspaces {

        }

        #workspaces button {
          background-color: @bgmodule;
          color: @fgcolor;
          padding: 0px;
          margin: 0px 1px 0px;
          min-width: 26px;
          border: 1px solid @gray;
            /* Use box-shadow instead of border so the text isn't offset */
        /*    box-shadow: inset 0 -3px transparent;*/
            /* border-radius: 0px; */
        }

        #workspaces button.active {
          padding: 0px 5px 0px;
          min-width: 26px;
          border: 1px solid ${colors.base.sun};
          /* Use box-shadow instead of border so the text isn't offset */
        /*    box-shadow: inset 0 -3px transparent;*/
          /* border-radius: 0px; */
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        #workspaces button:hover {
          /* box-shadow: inset 0 -3px #ffffff; */
          background-color: @gray;
          color: @fgcolor;
        }

        #workspaces button.focused {
          padding: 0px 2px 0px;
          min-width: 26px;
          border: 1px solid @fgcolor;
          /* box-shadow: inset 0 -3px #ffffff; */
        }

        #workspaces button.urgent {
          background-color: @urgent;
        }

        #window {
          font-family: "Noto Sans";
        }

        #submap {
          font-family: "Noto Sans";
            color: @accent1;
        }

        #backlight,
        #battery,
        #clock,
        #cpu,
        #custom-language,
        #custom-media,
        #custom-pacman,
        #custom-power,
        #custom-theme,
        #idle_inhibitor,
        #memory,
        #mode,
        #mpd,
        #network,
        #privacy,
        #pulseaudio,
        #systemd-failed-units,
        #temperature #cpu,
        #tray,
        #language {
          background-color: @bgmodule;
          border: 1px solid @gray;
          color: @fgcolor;
          padding: 0px 8px 0px;
          margin: 0px 0px 0px;
        }

        /* If workspaces is the leftmost module, omit left margin
        .modules-left > widget:first-child > #workspaces {
            margin-left: 0;
        }

         If workspaces is the rightmost module, omit right margin
        .modules-right > widget:last-child > #workspaces {
            margin-right: 0;
        }*/

        #battery {
          color: @accent3;
        }

        /* #battery.charging {
            color: #ffffff;
            background-color: #26A65B;
        } */

        @keyframes blink {
          to {
            background-color: @fgcolor;
            color: @accent6;
          }
        }

        #battery.critical:not(.charging) {
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
            background-color: @critical;
            color: @white;
        }

        #clock {
          border: 1px solid @fgcolor;
        }

        #cpu {
        }

        #memory {
        }

        #backlight {
        }

        #network {
        }

        #network.disconnected {
        }

        #pulseaudio {
        }

        #pulseaudio.muted {
        }

        #custom-power {
        }

        #custom-waylandvsxorg {
        }

        #custom-media {
        }

        #temperature {
        }

        #temperature.critical {
          background-color: @critical;
        }

        #tray {
          border: 1px solid @fgcolor;
          margin: 0px 2px 0px;
        }

        #mode {
          border-bottom: 1px solid @fgcolor;
        }

        #privacy {
          border: 1px solid @fgcolor;
          margin: 0px -2px 0px 2px;
        }

        #idle_inhibitor {
          background-color: @bgcolor;
          color: @fgcolor;
          margin: 0px 0px 0px 2px;
          padding: 0px 10px 0px 5px;
          min-width: 26px;
        }

        #idle_inhibitor.activated {
          background-color: @fgcolor;
          color: @bgcolor;
          min-width: 26px;
        }

        #custom-theme {
          margin: 0px 0px 0px;
          padding: 0px 10px 0px 5px;
          min-width: 26px;
        }

        #custom-theme.dark {
          background-color: @bgcolor;
          color: @fgcolor;
        }

        #custom-theme.light {
          background-color: @fgcolor;
          color: @bgcolor;
        }

        #custom-separator {
          color: @gray;
          margin: 0 0 0 0;
          padding-bottom: 0px;
        }
      '';
    };
  };
}
