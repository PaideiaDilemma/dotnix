{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    style = ''
      		@define-color critical #CA7081; /* critical color */
      		@define-color warning #92963A;  /* warning color */
      		@define-color fgcolor #FFF7ED;  /* foreground color */
      		@define-color bgcolor rgba(99, 99, 99, 0.8);  /* background color */
      		@define-color alert   #C27D40;

      		@define-color accent1 #CB7459;
      		@define-color accent2 #A38F2D;
      		@define-color accent3 #46A473;
      		@define-color accent4 #00A0BE;
      		@define-color accent5 #7E87D6;
      		@define-color accent6 #BD72A8;
      		@define-color gray #8F8F8F;
      		@define-color sky_p #BEBEBE;
      		@define-color sun_m #F2E6D4;
      		@define-color bgmodule @bgcolor;
      		@define-color bordermodule @gray;

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
      		  /* dorder-bottom: 0px solid rgba(100, 114, 125, 0.5); */
      		  color: @fgcolor;
      		  transition-property: background-color;
      		  transition-duration: .5s;
      		  border-radius: 5px;
      		  /*border-bottom: 1px solid @gray;*/
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
      		  border: 1px solid @bordermodule;
      		    /* Use box-shadow instead of border so the text isn't offset */
      		/*    box-shadow: inset 0 -3px transparent;*/
      		    /* border-radius: 0px; */
      		}

      		#workspaces button.active {
      		  padding: 0px 5px 0px;
      		  min-width: 26px;
      		  border: 1px solid #FFFDFB;
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

      		#clock,
      		#battery,
      		#temperature #cpu,
      		#temperature #gpu,
      		#cpu,
      		#memory,
      		#temperature,
      		#backlight,
      		#network,
      		#pulseaudio,
      		#custom-media,
      		#tray,
      		#mode,
      		#idle_inhibitor,
      		#custom-power,
      		#custom-pacman,
      		#custom-language,
      		#mpd,
      		#language {
      		  background-color: @bgmodule;
      		  border: 1px solid @bordermodule;
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
      		  color: @accent5;
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
      		/*    color: @critical;
      		    animation-name: blink;
      		    animation-duration: 0.5s;
      		    animation-timing-function: linear;
      		    animation-iteration-count: infinite;
      		    animation-direction: alternate;
      		*/  background-color: @critical;
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

      		#custom-pacman {
      		}

      		#custom-media {
      		}

      		#custom-media.custom-spotify {
      		}

      		#custom-media.custom-vlc {
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

      		#idle_inhibitor {
      		  border: 1px solid @accent3;
      		  margin: 0px 2px 0px;
      		  padding: 0px 10px 0px 5px;
      		  min-width: 26px;
      		}

      		#idle_inhibitor.activated {
      		  border: 1px solid @accent6;
      		  margin: 0px 2px 0px;
      		  padding: 0px 10px 0px 5px;
      		  min-width: 26px;
      		}

      		#custom-language {
      		}

      		#custom-separator {
      		  color: @gray;
      		  margin: 0 0 0 0;
      		  padding-bottom: 2px;
      		}
    '';
    settings = [{
      "layer" = "top"; # Waybar at top layer
      # "position" = "left"; # Waybar position (top|bottom|left|right)
      "height" = 27; # Waybar height (to be removed for auto height)
      "gtk-layer-shell" = true;
      "spacing" = 2;
      "width" = 1910; # Waybar width
      # Choose the order of the modules
      "modules-left" = [
        "idle_inhibitor"
        "hyprland/workspaces"
        "custom/separator"
        "hyprland/window"
      ];
      # "modules-center" = [];
      "modules-right" = [
        "cpu"
        "temperature#cpu"
        "temperature#gpu"
        "memory"
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
      "sway/workspaces" = {
        "disable-scroll" = true;
        "format" = "{name}";
        "all-outputs" = true;
      };
      "sway/mode" = {
        "format" = "<span style=\"italic\">{}</span>";
      };
      "sway/window" = {
        "format" = "{}";
        "all-outputs" = true;
      };
      "hyprland/workspaces" = {
        "format" = "{name}";

        "format-icons" = {
          "urgent" = "";
          #"active" = "";
          #"default" = "";
        };
        "all-outputs" = true;
        "sort-by-name" = false;
        "on-click" = "activate";
        "sort-by-coordinates" = true;
        "active-only" = false;
        "show-special" = true;
      };
      "sway/language" = {
        "format" = "{}";
        "on-click" = "swaymsg input type:keyboard xkb_switch_layout next";
      };
      "custom/language" = {
        "exec" = "swaymsg --type get_inputs | grep \"xkb_active_layout_name\" | sed -u '1!d; s/^.*xkb_active_layout_name\": \"#; s/ (US)#; s/\";#' && swaymsg --type subscribe --monitor '[\"input\"]' | sed -u 's/^.*xkb_active_layout_name\": \"#; s/\",.*$#; s/ (US)#'";
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
        "format" = "﬙ {usage}%";
        "on-click" = "wezterm --config font_size=10 start btop";
      };
      "memory" = {
        "format" = " {}%";
      };
      "temperature#cpu" = {
        # "thermal-zone" = 2;
        "hwmon-path" = "/sys/class/hwmon/hwmon0/temp1_input";
        "critical-threshold" = 80;
        # "format-critical" = "{temperatureC}°C {icon}";
        "format" = "<small><span style=\"italic\">CPU {icon}</span></small> {temperatureC}°C";
        "format-icons" = [ "" "" "" "" "" ];
        "interval" = 3;
      };
      "temperature#gpu" = {
        # "thermal-zone" = 2;
        "hwmon-path" = "/sys/class/hwmon/hwmon1/temp1_input";
        "critical-threshold" = 80;
        # "format-critical" = "{temperatureC}°C {icon}";
        "format" = "<small><span style=\"italic\">GPU {icon}</span></small> {temperatureC}°C";
        "format-icons" = [ "" "" "" "" "" ];
        "interval" = 3;
      };
      "backlight" = {
        # "device" = "acpi_video1";
        "format" = "{icon} {percent}%";
        "format-icons" = [ "" "" ];
      };
      "battery" = {
        "states" = {
          # "good" = 95;
          "warning" = 30;
          "critical" = 15;
        };
        "format" = "{icon} {capacity}%";
        "format-charging" = " {capacity}%";
        "format-plugged" = " {capacity}%";
        "format-alt" = "{icon} {time}";
        # "format-good" = ""; # An empty format will hide the module
        # "format-full" = "";
        "format-icons" = [ "" "" "" "" "" ];
      };
      "battery#bat2" = {
        "bat" = "BAT2";
      };
      "network" = {
        # "interface" = "wlp2*"; # (Optional) To force the use of this interface
        "format-wifi" = " {essid} ({signalStrength}%)";
        "format-ethernet" = " {ipaddr}/{cidr}";
        "format-linked" = " {ifname} (No IP)";
        "format-disconnected" = " Disconnected";
        "format-alt" = "{ifname}: {ipaddr}/{cidr}";
      };
      "pulseaudio" = {
        # "scroll-step" = 1; # %, can be a float
        "format" = "{icon} {volume}% {format_source}";
        "format-bluetooth" = "{volume}% {icon} {format_source}";
        "format-bluetooth-muted" = " {icon} {format_source}";
        "format-muted" = "ﱝ 0% {format_source}";
        "format-source" = " {volume}%";
        "format-source-muted" = "";
        "format-icons" = {
          "headphone" = "";
          "hands-free" = "";
          "headset" = "";
          "phone" = "";
          "portable" = "";
          "car" = "";
          "default" = [ "奄" "奔" "墳" ];
        };
        "on-click" = "pavucontrol";
      };
      "custom/waylandvsxorg" = {
        "exec" = "$HOME/bin/window_wayland_xorg.sh";
        "interval" = 2;
      };
    }];
  };
}
