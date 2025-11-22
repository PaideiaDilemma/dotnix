{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hyprhome;
  colors = config.colors;
  uwsm_exec = exec: "uwsm app -- ${exec}";
  rgbColor = hexcolor: "rgb(${removePrefix "#" hexcolor})";
  rgbaColor = hexcolor: alpha: "rgba(${removePrefix "#" hexcolor}${alpha})";
in {
  options.hyprhome.hyprland = {
    enable = mkOption {
      default = true;
      description = "Whether to enable the hyprland desktop.";
      type = types.bool;
    };

    enableAnimations = mkOption {
      default = true;
      description = "Enable animations";
      type = types.bool;
    };

    extraConfig = mkOption {
      type = types.str;
      default = "";
    };

    isVirtualMachine = mkOption {
      type = types.bool;
      default = false;
    };

    terminal = mkOption {
      type = types.str;
      default = cfg.terminal;
    };
  };

  config = mkIf (cfg.gui.enable && cfg.hyprland.enable) {
    home.packages = with pkgs; [
      deepinV20HyprCursors
      hyprlock
      hyprpicker
      hyprsetwallpaper
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      networkmanagerapplet
      swww
      uwsm
      waybar
      hyprsunset
    ];

    home.file."media/picture/wal.png".source = ./wal.png;
    home.file."media/picture/avatar.png".source = ./avatar.png;
    home.file.".icons/DeepinV20HyprCursors".source = "${pkgs.deepinV20HyprCursors}/share/icons/DeepinV20HyprCursors";

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false; # USWM instead

      settings = {
        "$terminal" = cfg.hyprland.terminal;
        "$sun_p" = rgbColor colors.base.sun';
        "$sun" = rgbColor colors.base.sun;
        "$sun_m" = rgbColor colors.base.sun_;
        "$sky_p" = rgbColor colors.base.sky';
        "$sky" = rgbColor colors.base.sky;
        "$sky_m" = rgbColor colors.base.sky_;
        "$shade_p" = rgbColor colors.base.shade';
        "$shade" = rgbColor colors.base.shade;
        "$shade_m" = rgbColor colors.base.shade_;
        "$red" = rgbColor colors.accent.red;
        "$orange" = rgbColor colors.accent.orange;
        "$yellow" = rgbColor colors.accent.yellow;
        "$green" = rgbColor colors.accent.green;
        "$cyan" = rgbColor colors.accent.cyan;
        "$blue" = rgbColor colors.accent.blue;
        "$purple" = rgbColor colors.accent.purple;

        input = {
          "kb_layout" = "eu";
          "follow_mouse" = 1;
          "mouse_refocus" = 0;
          #natural_scroll = 0;
          "kb_options" = "caps:swapescape,altwin:menu_win";
        };

        exec-once = [
          (uwsm_exec "swww-daemon")
          (uwsm_exec "waybar")
          (uwsm_exec "kdeconnect-indicator")
          (uwsm_exec "nm-applet")
          (uwsm_exec "hyprsunset")
          (uwsm_exec "/home/max/desk/clipzwl/result/bin/clipzwl init") # dev
          "hyprctl setcursor DeepinV20HyprCursors 32"
        ];

        monitor =
          [",preferred,auto-center-up,1"]
          ++ mapAttrsToList (
            name: monitor: "${name}, ${monitor.resolution}, ${monitor.position or "0x0"}, ${monitor.scale or "1"}, transform, ${monitor.transform or "0"}"
          )
          cfg.gui.staticMonitors;

        workspace =
          mapAttrsToList (
            name: monitor: "${monitor.initalWorkspace}, monitor:${name}, default:true, persistent:true"
          )
          cfg.gui.staticMonitors;

        exec =
          (mapAttrsToList (
              name: monitor: "sleep 1 && swww img -o ${name} ~/media/picture/wal${name}.png"
            )
            cfg.gui.staticMonitors)
          ++ (
            if (lib.attrNames cfg.gui.staticMonitors == [])
            then ["swww img ~/media/picture/wal.png"]
            else []
          );

        general = {
          gaps_in = 1;
          gaps_out = 2;
          border_size = 1;
          snap.enabled = 1;
          "col.active_border" = rgbColor colors.base.sun';
          "col.inactive_border" = rgbaColor colors.base.sky "a0";
        };

        decoration = {
          rounding = 6;
          shadow = {
            enabled = true;
            range = 5;
            render_power = 4;
            color = rgbaColor colors.base.shade "a0";
          };
        };

        render = {
          new_render_scheduling = true;
        };

        animations = {
          enabled =
            if cfg.hyprland.enableAnimations
            then "1"
            else "0";

          bezier = [
            "linear, 1, 1, 0, 0"
            "equal, 1, 0.5, 0, 0.5"
            "outCirc, 0.075, 0.82, 0.165, 1"
            "inCirc, 0.6, 0.04, 0.98, 0.335"
            "inOutCirc, 0.785, 0.135, 0.15, 0.86"
          ];

          animation = [
            "windows, 1, 2, inOutCirc, slide"
            "windowsOut, 1, 2, linear, popin 80%"
            "windowsIn, 1, 2, inOutCirc, slide"
            "windowsMove, 1, 2, inOutCirc"
            "fadeOut, 1, 1, linear"
            "fadeIn, 1, 2, inOutCirc"
            "fadeLayersIn, 1, 2, inOutCirc"
            "fadeLayersOut, 1, 1, linear"
            "workspaces, 1, 2, inOutCirc, slidevert"
            "specialWorkspace, 1, 3, inCirc"
            "border, 1, 3, linear"
            #"borderangle, 1, 20, const, loop";
          ];
        };

        dwindle = {
          pseudotile = 0;
          preserve_split = true;
          smart_split = true;
          # special_scale_factor = 0.5
        };

        misc = {
          #layers_hog_keyboard_focus = 0
          #cursor_zoom_factor = 1.5
          #cursor_zoom_rigid = 1
          key_press_enables_dpms = 1;
          #mouse_move_enables_dpms = 1;
          disable_splash_rendering = 1;
          disable_hyprland_logo = 1;
          force_default_wallpaper = 0;
        };

        ecosystem = {
          enforce_permissions = true;
        };

        permission = [
          "${lib.escapeRegex (lib.getExe pkgs.hyprlock)}, screencopy, allow"
          "${lib.escapeRegex (lib.getExe pkgs.grim)}, screencopy, allow"
          "${lib.escapeRegex (toString pkgs.xdg-desktop-portal-hyprland)}/libexec/.xdg-desktop-portal-hyprland-wrapped, screencopy, allow"
          "${lib.escapeRegex (toString pkgs.obs-studio)}/bin/.obs-wrapped, screencopy, allow"
        ];

        blurls = [
          "rofi"
          "launcher"
          "waybar"
        ];

        windowrule = [
          "float, class:kvantummanager"
          "float, class:org.gnome.Settings"
          "float, class:Lxappearance"
          "float, class:obs"
          "float, class:zathura"
          "float, class:feh"
          "float, class:qemu"
          #"float, DesktopEditors"
          "float, class:biz.ntinfo.die"
          "float, class:Ultimaker Cura"
          "float, class:Pinentry-gtk-2"
          #"float, title:^(Ghidra:)(.*)$"
          "float, title:^(wlroots)(.*)$"
          "suppressevent fullscreen, class:firefox, floating:1"
          "stayfocused, class:^(pinentry-)"
          "float, class:nm-connection-editor"
          "float, class:org.kde.kdeconnect-settings"
          "float, class:org.kde.kdeconnect.app"
          "float, class:org.pulseaudio.pavucontrol"
          "float, class:re.rizin.cutter, title:^(Open).*$"
          "float, class:re.rizin.cutter, title:^Load Options$"
          "float, class:vlc"
          "float, title:Bluetooth Devices"
        ];

        bindm = [
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
        ];

        bindl = let
          screenshot_dir = "$HOME/media/picture/screenshots/";
          screenshot_cmd = target: "grimblast --notify copysave ${target} \"${screenshot_dir}$(date +'%H%M%S_%a%d%h%y_${target}').png\"";
        in [
          # Screenshots
          "SUPERSHIFT, S, exec, ${screenshot_cmd "area"}"
          "SUPERCTRL, S, exec, ${screenshot_cmd "output"}"
        ];

        # Repeating
        binde = [
          # Zooming
          "SUPER, I, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 + 0.4}')"
          "SUPER, O, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 - 0.4}')"
          "CONTROL, Escape, exec, makoctl dismiss"
          "SHIFTCONTROL, Escape, exec, makoctl dismiss --all"
        ];

        binds = {
          scroll_event_delay = "10";
        };

        # Long press
        bindo = [
          "ALT, L, exec, hyprlock"
        ];

        bind = [
          # Launchers
          "SUPER, Return, exec, $terminal"
          "SUPERSHIFT, Return, exec, $terminal ipython"
          "SUPER, E, exec, uwsm app -- dolphin"

          # Rofi menus
          "SUPER, D, exec, rofi -show drun -show-icons -run-command \"uwsm app -- {cmd}\""
          "SUPER, R, exec, rofi -show run -run-shell-command '{terminal} fish -ic \"{cmd} && read\"'"
          "SUPER, F, exec, rofi -show window -show-icons"
          # Dev
          "SUPER, V, exec, /home/max/desk/clipzwl/result/bin/clipzwl restore \"$(/home/max/desk/clipzwl/result/bin/clipzwl list 1000 | rofi -dmenu | awk '{print $1}')\""

          # Notification Control
          "CONTROLSHIFT, Escape, exec, makoctl dismiss --all"
          "SUPERSHIFT, Escape, exec, makoctl invoke"

          # tofi menus
          #$tofi_theme = ~/.config/tofi/top_left
          #"SUPER, D, exec, tofi-drun --drun-launch=true --include $tofi_theme"
          #"SUPER, R, exec, tofi-run --include $tofi_theme | xargs sh -c"
          #"SUPERSHIFT, P, exec, $terminal fish -c \"pass clip && sleep 1\""
          #"SUPERSHIFT, R, exec, wlclipmgr restore -i \"$(wlclipmgr list -l 100 | tofi --include $tofi_theme | awk '{print $1}')\""

          # Window Manager
          "SUPER, C, killactive, "
          "SUPERSHIFT, C, killactive"
          "SUPERSHIFT, Space, togglefloating, "
          "SUPER, P, pseudo, "
          "SUPER, M, fullscreen, "
          #"ALT, P, pin"

          "SUPERSHIFT, E, exit, "

          "SUPER, left, movefocus, l"
          "SUPER, right, movefocus, r"
          "SUPER, up, movefocus, u"
          "SUPER, down, movefocus, d"

          "SUPER, h, movefocus, l"
          "SUPER, l, movefocus, r"
          "SUPER, k, movefocus, u"
          "SUPER, j, movefocus, d"

          "SUPERSHIFT, h, movewindow, l"
          "SUPERSHIFT, l, movewindow, r"
          "SUPERSHIFT, k, movewindow, u"
          "SUPERSHIFT, j, movewindow, d"

          "SUPER, q, workspace, r-1"
          "SUPER, w, workspace, r+1"
          "SUPER, 1, workspace, m~1"
          "SUPER, 2, workspace, m~2"
          "SUPER, 3, workspace, m~3"
          "SUPER, 4, workspace, m~4"
          "SUPER, 5, workspace, m~5"
          "SUPER, 6, workspace, m~6"
          "SUPER, 7, workspace, m~7"
          "SUPER, 8, workspace, m~8"
          "SUPER, 9, workspace, m~9"
          "SUPER, 0, workspace, m~10"
          "SUPER, a, togglespecialworkspace"

          "SUPERSHIFT, q, movetoworkspace, r-1"
          "SUPERSHIFT, w, movetoworkspace, r+1"
          "SUPERSHIFT, 1, movetoworkspace, m~1"
          "SUPERSHIFT, 2, movetoworkspace, m~2"
          "SUPERSHIFT, 3, movetoworkspace, m~3"
          "SUPERSHIFT, 4, movetoworkspace, m~4"
          "SUPERSHIFT, 5, movetoworkspace, m~5"
          "SUPERSHIFT, 6, movetoworkspace, m~6"
          "SUPERSHIFT, 7, movetoworkspace, m~7"
          "SUPERSHIFT, 8, movetoworkspace, m~8"
          "SUPERSHIFT, 9, movetoworkspace, m~9"
          "SUPERSHIFT, 0, movetoworkspace, m~10"
          "SUPERSHIFT, a, movetoworkspace, special"

          "SUPER, semicolon, swapnext"
          "SUPER, apostrophe, togglesplit"

          #", code:276, swapnext"
          #", code:276, togglesplit"

          #"ALT, Space, togglegroup"
          #"ALT, j, changegroupactive, f"
          #"ALT, k, changegroupactive, b"
          #"ALT, c, togglesplit"
          # Zoom
          "SUPER, mouse_down, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 1.2}')"
          "SUPER, mouse_up, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 0.8}')"
          "SUPER, 0, exec, hyprctl -q keyword cursor:zoom_factor 1"
        ];
      };

      extraConfig =
        ''
          # SUBMAPS
          bind = SUPERSHIFT, p, submap, passthrough
          submap = passthrough
          bind = SUPERSHIFT, p, submap, reset
          submap = reset
          # ------------

          bind = SUPER, E, submap, resize
          submap = resize

          binde=, h, resizeactive, 40 0
          binde=, l, resizeactive, -40 0
          binde=, k, resizeactive, 0 -40
          binde=, j, resizeactive, 0 40

          bind = ALT, R, submap, reset
          bind = , escape, submap, reset

          submap = reset
          # ------------

          bind = SUPER, space, submap, move
          submap = move

          bind = , L, focusmonitor, +1
          bind = , H, focusmonitor, -1

          bind = , J, workspace, r+1
          bind = , K, workspace, r-1
          bind = , 1, workspace, m~1
          bind = , 2, workspace, m~2
          bind = , 3, workspace, m~3
          bind = , 4, workspace, m~4
          bind = , 5, workspace, m~5
          bind = , 6, workspace, m~6
          bind = , 7, workspace, m~7
          bind = , 8, workspace, m~8
          bind = , 9, workspace, m~9
          bind = , 0, workspace, m~10
          bind = , a, togglespecialworkspace

          bind = SHIFT, L, movecurrentworkspacetomonitor, +1
          bind = SHIFT, H, movecurrentworkspacetomonitor, -1

          bind = SHIFT, J, movetoworkspacesilent, r+1
          bind = SHIFT, K, movetoworkspacesilent, r-1
          bind = SHIFT, 1, movetoworkspacesilent, m~1
          bind = SHIFT, 2, movetoworkspacesilent, m~2
          bind = SHIFT, 3, movetoworkspacesilent, m~3
          bind = SHIFT, 4, movetoworkspacesilent, m~4
          bind = SHIFT, 5, movetoworkspacesilent, m~5
          bind = SHIFT, 6, movetoworkspacesilent, m~6
          bind = SHIFT, 7, movetoworkspacesilent, m~7
          bind = SHIFT, 8, movetoworkspacesilent, m~8
          bind = SHIFT, 9, movetoworkspacesilent, m~9
          bind = SHIFT, 0, movetoworkspacesilent, m~10
          bind = SHIFT, a, movetoworkspacesilent, special

          bind = SUPER, J, movetoworkspace, r+1
          bind = SUPER, K, movetoworkspace, r-1
          bind = SUPER, 1, movetoworkspace, m~1
          bind = SUPER, 2, movetoworkspace, m~2
          bind = SUPER, 3, movetoworkspace, m~3
          bind = SUPER, 4, movetoworkspace, m~4
          bind = SUPER, 5, movetoworkspace, m~5
          bind = SUPER, 6, movetoworkspace, m~6
          bind = SUPER, 7, movetoworkspace, m~7
          bind = SUPER, 8, movetoworkspace, m~8
          bind = SUPER, 9, movetoworkspace, m~9
          bind = SUPER, 0, movetoworkspace, m~10
          bind = SUPER, a, movetoworkspace, special

          bind = SUPER, space, submap, reset
          bind = , space, submap, reset
          bind = , escape, submap, reset

          submap = reset
          # ------------
          #
          # Smart gaps
          #workspace = w[tv1]s[false], gapsout:0, gapsin:0
          #workspace = f[1]s[false], gapsout:0, gapsin:0
          #windowrule = bordersize 0, floating:0, onworkspace:w[tv1]s[false]
          #windowrule = rounding 0, floating:0, onworkspace:w[tv1]s[false]
          #windowrule = bordersize 0, floating:0, onworkspace:f[1]s[false]
          #windowrule = rounding 0, floating:0, onworkspace:f[1]s[false]
        ''
        + cfg.hyprland.extraConfig;
    };

    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "hyprlock";
          #unlock_cmd = notify-send "Unlock cmd"
          before_sleep_cmd = "hyprlock --no-fade-in";
          #after_resume_cmd = notify-send "After resume cmd"
          #ignore_dbus_inhibit = true;
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
          {
            timeout = 800;
            on-timeout = "hyprctl dispatch dpms off";
          }
          {
            timeout = 100;
            on-timeout = "hyprsetwallpaper -g -c";
          }
        ];
      };
    };

    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          hide_cursor = false;
          ignore_empty_input = true;
        };

        bezier = [
          "linear, 1, 1, 0, 0"
          "equal, 1, 0.5, 0, 0.5"
          "outCirc, 0.075, 0.82, 0.165, 1"
          "inCirc, 0.6, 0.04, 0.98, 0.335"
          "inOutCirc, 0.785, 0.135, 0.15, 0.86"
        ];

        animation = [
          "fade, 1, 4, inCirc"
          "inputFieldDots, 1, 2, linear"
          "inputFieldFade, 1, 4, outCirc"
          "inputFieldWidth, 1, 3, inOutCirc"
          "inputFieldColors, 1, 6, linear"
        ];

        input-field = [
          {
            monitor = ""; #if (cfg.gui.primaryMonitor != "") then cfg.gui.primaryMonitor else "";
            position = "0, -20";
            size = "250, 40";

            fade_timeout = 4000;

            rounding = 15;

            outline_thickness = 4;

            fail_color = rgbColor colors.accent.red;

            outer_color = rgbaColor colors.base.sun "a0";
            inner_color = rgbaColor colors.base.sun "00";
            check_color = rgbColor colors.accent.green;
            font_color = rgbColor colors.base.sky;
            capslock_color = rgbColor colors.accent.red;

            dots_size = 0.4;
            dots_spacing = 0.10;
            dots_rounding = 0;
            dots_text_format = "";
            font_family = "FiraMono Nerd Font Propo";

            placeholder_text = "<i>$PAMPROMPT</i>";

            halign = "center";
            valign = "center";
          }
        ];

        label = [
          {
            monitor = ""; #if (cfg.gui.primaryMonitor != "") then cfg.gui.primaryMonitor else "";
            position = "0, 100";

            text = "$TIME";
            #text = "<b>$TIME_HH</b><span foreground=\"#${colors.base.sky}\">:</span><b>$TIME_MM</b><span style=\"smallest\" foreground=\"#${colors.base.sky}\">:</span><b>$TIME_SS</b>";
            color = rgbColor colors.base.sun;
            font_size = 40;
            font_family = "Noto Sans";

            halign = "center";
            valign = "center";
          }
          {
            monitor = ""; #if (cfg.gui.primaryMonitor != "") then cfg.gui.primaryMonitor else "";
            position = "0, 145";
            text = "cmd[update:10000] ${pkgs.coreutils}/bin/date '+%A %d %B %Y'";
            color = rgbaColor colors.base.sky' "A0";
            font_size = 24;
            font_family = "Noto Sans";

            halign = "center";
            valign = "center";
          }
        ];

        /*
          images = [{
          monitor = if (cfg.gui.primaryMonitor != "") then cfg.gui.primaryMonitor else "";
          path = "~/media/picture/avatar.png";
          size = 50;
          rounding = 20;

          position = {
            x = 0;
            y = 10;
          };

          halign = "center";
          valign = "bottom";
        }];
        */

        background = [
          {
            monitor = "";
            path = "screenshot";
            color = rgbColor colors.base.shade;
            blur_passes = 2;
            blur_size = 10;
          }
        ];
      };
    };
  };
}
