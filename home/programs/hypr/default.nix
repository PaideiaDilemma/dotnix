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
  rgbColor = hexcolor: "rgb(${removePrefix "#" hexcolor})";
  rgbaColor = hexcolor: alpha: "rgba(${removePrefix "#" hexcolor}${alpha})";
in {
  imports = [
    ./hyprland-environment.nix
  ];

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
      chayang
      deepinV20HyprCursors
      grim
      hyprpicker
      hyprsetwallpaper
      hyprlock
      networkmanagerapplet
      slurp
      swww
      waybar
      wlsunset
    ];

    home.file."media/picture/wal.png".source = ./wal.png;
    home.file."media/picture/avatar.png".source = ./avatar.png;
    home.file.".icons/DeepinV20HyprCursors".source = "${pkgs.deepinV20HyprCursors}/share/icons/DeepinV20HyprCursors";

    systemd.user.targets.hyprland-session.Unit.Wants = ["xdg-desktop-autostart.target"];

    home.sessionVariables = mkIf cfg.hyprland.isVirtualMachine {
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      plugins = [
        #inputs.hyprharpoon.packages.${pkgs.system}.hyprharpoon
      ];

      systemd = {
        enable = true;
        variables = ["--all"];
      };

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
        "$red" = rgbColor colors.seven.red;
        "$orange" = rgbColor colors.seven.orange;
        "$yellow" = rgbColor colors.seven.yellow;
        "$green" = rgbColor colors.seven.green;
        "$cyan" = rgbColor colors.seven.cyan;
        "$blue" = rgbColor colors.seven.blue;
        "$purple" = rgbColor colors.seven.purple;

        input = {
          "kb_layout" = "eu";
          "follow_mouse" = 1;
          "mouse_refocus" = 0;
          #natural_scroll = 0;
          "kb_options " = "caps:swapescape";
        };

        exec-once = [
          "dbus-update-activation-environment --systemd --all"
          "waybar"
          "swww-daemon"
          "wlsunset -l 48.2, -L 16.3 -t 4800"
          "wlclipmgr watch --block \"password store sleep:2\""
          "kdeconnect-indicator"
          "nm-applet"
        ];

        #monitor=",1920x1080,auto,1";
        monitor =
          mapAttrsToList (
            name: monitor: "${name},${monitor.resolution},${monitor.position},${monitor.scale}"
          )
          cfg.gui.staticMonitors;

        workspace =
          mapAttrsToList (
            name: monitor: "${monitor.initalWorkspace},monitor:${name},default:true,persistent:true"
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
          sensitivity = 1.0; # for mouse cursor
          gaps_in = 4;
          gaps_out = 5;
          border_size = 1;
          "col.active_border" = rgbColor colors.base.sun;
          "col.inactive_border" = rgbaColor colors.base.sky "a0";
          apply_sens_to_raw = 0; # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
        };

        decoration = {
          rounding = 6;
          drop_shadow = 1;
          shadow_range = 14;
          shadow_render_power = 3;
          shadow_ignore_window = 1;
          "col.shadow" = "0xa0$shade_m";
        };

        animations = {
          enabled =
            if cfg.hyprland.enableAnimations
            then "1"
            else "0";
          bezier = [
            "const,0.25,0.25,0.75,0.75"
            "ease2,0.57,0.15,0.40,0.85"
            #"ease-out2,0.58,0.45,0.58,1"
            "ease-out2,0.75,0.8,0.58,1"
            #bezier = "ease-in2,0,0.45,0.58,0.58"
            "ease-in2,0.5,0.75,0.58,0.58"
            "weird,-0.09,0,0.19,1"
            "special,0.5,0.9,0,0.72"
          ];

          animation = [
            "windowsIn,1,2,ease-in2,popin 80%"
            "windowsOut,1,2,ease-out2,popin 80%"
            "fadeIn,1,2,ease-in2"
            "fadeOut,1,2,ease-out2"
            "workspaces,1,2,ease2,slidevert"
            "specialWorkspace,1,4,special,slidevert"
            "windowsMove,1,2,weird"
            "border,1,9,special"
            #"borderangle,1,20,const,loop";
          ];
        };

        dwindle = {
          pseudotile = 0;
          preserve_split = true;
          smart_split = true;
          # special_scale_factor = 0.5
          # no_gaps_when_only = true
        };

        misc = {
          #layers_hog_keyboard_focus = 0
          #cursor_zoom_factor = 1.5
          #cursor_zoom_rigid = 1
          disable_splash_rendering = 1;
          disable_hyprland_logo = 1;
          force_default_wallpaper = 0;
        };

        blurls = [
          "rofi"
          "launcher"
          "waybar"
        ];

        windowrule = [
          "float,kvantummanager"
          "float,org.gnome.Settings"
          "float,Lxappearance"
          "float,obs"
          "float,zathura"
          "float,feh"
          "float,qemu"
          #"float,DesktopEditors"
          "float,biz.ntinfo.die"
          "float,Ultimaker Cura"
          "float,Pinentry-gtk-2"
          "float,title:^(Ghidra:)(.*)$"
          "float,title:^(wlroots)(.*)$"
        ];

        windowrulev2 = [
          "suppressevent fullscreen,class:firefox,floating:1"
          "float,class:re.rizin.cutter,title:^(Open).*$"
          "float,class:re.rizin.cutter,title:^Load Options$"
          "stayfocused,class:^(ghidra-Ghidra)$,floating:1,fullscreen:0,initialTitle:^(CodeBrowser.*)$"
        ];

        bindm = [
          "SUPER,mouse:272,movewindow"
          "SUPER,mouse:273,resizewindow"
        ];

        bind = let
          screenshot_dir = "$HOME/media/picture/screenshots/";
          screenshot_cmd = select: "filename=$(date +'%H%M%S_%a%d%h%y_${
            if select
            then "sel"
            else "full"
          }') && grim ${
            if select
            then "-g \"$(slurp)\""
            else ""
          } \"${screenshot_dir}$filename.png\" && wl-copy < \"$screenshot_dir$filename.png\" && notify-send \"Screenshot taken $filename.png\"";
        in [
          # Launchers
          "SUPER,Return,exec,$terminal"
          "SUPERSHIFT,Return,exec,$terminal ipython"
          "SUPER,E,exec,dolphin"
          "SUPER,B,exec,chromium"
          "SUPERSHIFT,l,exec,hyprlock"

          # Rofi menus
          "SUPER,D,exec,rofi -show drun -show-icons"
          "SUPER,R,exec,rofi -show run -run-shell-command '{terminal} zsh -ic \"{cmd} && read\"'"
          "SUPER,F,exec,rofi -show window -show-icons"
          "SUPERSHIFT,P,exec,rofi-pass"
          "SUPER,V,exec,wlclipmgr restore -i \"$(wlclipmgr list -l 100 | rofi -dmenu | awk '{print $1}')\""

          # Screenshots
          "SUPERSHIFT,S,exec,${screenshot_cmd true}"
          "SUPERCTRL,S,exec,${screenshot_cmd false}"

          # Notification Control
          "CONTROL,Escape,exec,makoctl dismiss"
          "CONTROLSHIFT,Escape,exec,makoctl dismiss"

          # tofi menus
          #$tofi_theme = ~/.config/tofi/top_left
          #"SUPER,D,exec,tofi-drun --drun-launch=true --include $tofi_theme"
          #"SUPER,R,exec,tofi-run --include $tofi_theme | xargs sh -c"
          #"SUPERSHIFT,P,exec,$terminal fish -c \"pass clip && sleep 1\""
          #"SUPERSHIFT,R,exec,wlclipmgr restore -i \"$(wlclipmgr list -l 100 | tofi --include $tofi_theme | awk '{print $1}')\""

          # Window Manager
          "SUPER,C,killactive,"
          "SUPERSHIFT,C,killactive"
          "SUPERSHIFT,Space,togglefloating,"
          "SUPER,P,pseudo,"
          "SUPER,M,fullscreen,"
          "ALT,P,pin"

          "SUPERSHIFT,E,exit,"

          "SUPER,left,movefocus,l"
          "SUPER,right,movefocus,r"
          "SUPER,up,movefocus,u"
          "SUPER,down,movefocus,d"

          "SUPER,h,movefocus,l"
          "SUPER,l,movefocus,r"
          "SUPER,k,movefocus,u"
          "SUPER,j,movefocus,d"

          "SUPER,w,workspace,+1"
          "SUPER,q,workspace,-1"
          "SUPER,1,workspace,1"
          "SUPER,2,workspace,2"
          "SUPER,3,workspace,3"
          "SUPER,4,workspace,4"
          "SUPER,5,workspace,5"
          "SUPER,6,workspace,6"
          "SUPER,7,workspace,7"
          "SUPER,8,workspace,8"
          "SUPER,9,workspace,9"
          "SUPER,0,workspace,10"
          "SUPER,a,togglespecialworkspace"

          "ALT,w,movetoworkspace,+1 # Monitor Num"
          "ALT,q,movetoworkspace,-1 # Monitor Num"
          "ALT,1,movetoworkspace,1"
          "ALT,2,movetoworkspace,2"
          "ALT,3,movetoworkspace,3"
          "ALT,4,movetoworkspace,4"
          "ALT,5,movetoworkspace,5"
          "ALT,6,movetoworkspace,6"
          "ALT,7,movetoworkspace,7"
          "ALT,8,movetoworkspace,8"
          "ALT,9,movetoworkspace,9"
          "ALT,0,movetoworkspace,10"
          "ALT,a,movetoworkspace,special"

          "SUPERSHIFT,w,movetoworkspacesilent,+1 # Monitor Num"
          "SUPERSHIFT,q,movetoworkspacesilent,-1 # Monitor Num"
          "SUPERSHIFT,1,movetoworkspacesilent,1"
          "SUPERSHIFT,2,movetoworkspacesilent,2"
          "SUPERSHIFT,3,movetoworkspacesilent,3"
          "SUPERSHIFT,4,movetoworkspacesilent,4"
          "SUPERSHIFT,5,movetoworkspacesilent,5"
          "SUPERSHIFT,6,movetoworkspacesilent,6"
          "SUPERSHIFT,7,movetoworkspacesilent,7"
          "SUPERSHIFT,8,movetoworkspacesilent,8"
          "SUPERSHIFT,9,movetoworkspacesilent,9"
          "SUPERSHIFT,0,movetoworkspacesilent,10"
          "SUPERSHIFT,a,movetoworkspacesilent,special"

          "SUPERALT,1,movecurrentworkspacetomonitor,eDP-1"
          "SUPERALT,2,movecurrentworkspacetomonitor,HDMI-A-1"

          "SUPER,semicolon,swapnext"
          "SUPER,apostrophe,togglesplit"

          "ALT,Space,togglegroup"
          "ALT,j,changegroupactive,f"
          "ALT,k,changegroupactive,b"
          "ALT,c,togglesplit"
        ];

        plugin = {
          harpoon = {
            select_trigger = ",Menu";
            add_trigger = "SHIFT,Menu";
          };
        };
      };

      extraConfig =
        ''
          # SUBMAPS
          bind = ALT,p,submap,passthrough
          submap = passthrough
          # passthrough
          bind = ALT,p,submap,reset
          # ~passthrough
          submap = reset

          bind = ALT,R,submap,resize
          submap = resize
          # resize
          binde=,h,resizeactive,40 0
          binde=,l,resizeactive,-40 0
          binde=,k,resizeactive,0 -40
          binde=,j,resizeactive,0 40

          bind = ALT,R,submap,reset
          bind = ,escape,submap,reset
          # ~resize
          submap = reset
        ''
        + cfg.hyprland.extraConfig;
    };

    services.hypridle = {
      enable = true;

      #package = inputs.hypridle.packages.${pkgs.system}.hypridle;

      settings = {
        general = {
          lockCmd = "pidof hyprlock || hyprlock";
          #unlock_cmd = notify-send "Unlock cmd"
          beforeSleepCmd = "loginctl lock-session";
          #after_resume_cmd = notify-send "After resume cmd"
          ignoreDbusInhibit = true;
        };

        listeners = [
          {
            timeout = 300;
            onTimeout = "pidof hyprlock || hyprlock";
          }
          {
            timeout = 800;
            onTimeout = "systemctl suspend";
          }
          {
            timeout = 100;
            onTimeout = "hyprsetwallpaper -g -c";
          }
        ];
      };
    };

    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          grace = 4;
          hide_cursor = true;
          no_fade_in = true;
          no_fade_out = true;
          #ignore_empty_input = true;
        };

        input-field = [
          {
            monitor = ""; #if (cfg.gui.primaryMonitor != "") then cfg.gui.primaryMonitor else "";
            position = "0, -20";
            size = "250, 50";

            fade_timeout = 2500;

            rounding = 15;

            outline_thickness = 4;

            fail_color = rgbColor colors.six.red;
            fail_transition = 400;

            outer_color = rgbaColor colors.base.sun "a0";
            inner_color = rgbColor colors.base.sun;
            font_color = rgbColor colors.base.sky;
            capslock_color = rgbColor colors.six.red;

            dots_size = 0.4;
            dots_spacing = 0.10;
            dots_rounding = -2;

            placeholder_text = "<i>$PROMPT</i>";

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
            position = "0, 125";
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
