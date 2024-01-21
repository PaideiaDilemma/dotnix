{ config, lib, pkgs, hostname, ... }:

{
  imports = [
    #./hyprland-environment.nix
  ];

  home.packages = with pkgs; [
    waybar
  ];

  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];

  xdg.configFile."hypr/hyprland.conf".text = ''
    # Include device specific config
    source = ~/.config/hypr/device.conf

    $terminal = foot
    $sun_p = FFFDFB
    $sun = FFF7ED
    $sun_m = F2E6D4
    $sky_p = BEBEBE
    $sky = 8F8F8F
    $sky_m = 636363
    $shade_p = 3E4044
    $shafe = 303338
    $shade_m = 24272B
    $red = CA7081
    $orange = C27D40
    $yellow = 92963A
    $green = 3EA57B
    $cyan = 00A0BA
    $blue = 6E8DD5
    $purple = AC78BD

    env = WLR_NO_HARDWARE_CURSORS,1
    #env = WLR_RENDERER,"vulkan"
    env = WLR_RENDERER_ALLOW_SOFTWARE,1

    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_TYPE,wayland
    env = XDG_SESSION_DESKTOP,Hyprland

    #env = XCURSOR_SIZE,24
    #env = XCURSOR_THEME,PearWhiteCursors
    #SDL_VIDEODRIVER,wayland

    env = QT_AUTO_SCREEN_SCALE_FACTOR,1
    env = QT_QPA_PLATFORM,wayland;xcb
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
    env = QT_QPA_PLATFORMTHEME,qt6ct

    env = MOZ_ENABLE_WAYLAND,1

    env = BROWSER,firefox
    env = GNUPGHOME,$HOME/.config/gnupg/
    env = PASSWORD_STORE_DIR,$HOME/.config/pass

    env = _JAVA_AWT_WM_NONREPARENTING,1
    env = NVIM_APPNAME,lazyvim

    exec-once = waybar
    exec-once = hyprpaper
    exec-once = hyprctl setcursor PearWhiteCursors 24
    exec-once = wlsunset -l 48.2, -L 16.3 -t 4800
    # TODO!!!
    #exec-once = /usr/lib/kdeconnectd
    #exec-once = kdeconnect-indicator
    #exec-once = wlclipmgr watch --block "password store sleep:2"
    #exec-once = swayidle -w timeout 300 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
    #exec-once = swayidle -w timeout 20 '~/.config/scripts/hyprsetwallpaper.py -g -c'
    #before-sleep 'swaylock -f -c 000000'timeout 600 'swaylock -f -c 000000'

    general {
        sensitivity = 1.0 # for mouse cursor

        gaps_in = 4
        gaps_out = 5
        border_size = 1
        col.active_border = 0xff$sun
        #col.active_border = 0xff$sun 0xff$cyan 0xff$sun
        col.inactive_border = 0xa0$sky

        #resize_on_border = 1

        apply_sens_to_raw = 0 # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
    }

    decoration {
        rounding = 6

        drop_shadow = 1
        shadow_range = 14
        shadow_render_power = 3
        shadow_ignore_window = 1
        col.shadow = 0xa0$shade_m
    }

    animations {
        enabled = 1
        bezier = const,0.25,0.25,0.75,0.75
        bezier = ease2,0.57,0.15,0.40,0.85
        #bezier = ease-out2,0.58,0.45,0.58,1
        bezier = ease-out2,0.75,0.8,0.58,1
        #bezier = ease-in2,0,0.45,0.58,0.58
        bezier = ease-in2,0.5,0.75,0.58,0.58
        bezier = weird,-0.09,0,0.19,1
        animation = windowsIn,1,2,ease-in2,popin 80%
        animation = windowsOut,1,2,ease-out2,popin 80%
        animation = fadeIn,1,2,ease-in2
        animation = fadeOut,1,2,ease-out2
        animation = workspaces,1,2,ease2,slidevert
        bezier = special,0.5,0.9,0,0.72
        animation = specialWorkspace,1,4,special,slidevert
        animation = windowsMove,1,2,weird
        animation = border,1,9,special
        #animation = borderangle,1,20,const,loop
    }

    dwindle {
        pseudotile = 0 # enable pseudotiling on dwindle
        preserve_split = true
        smart_split = true
        # special_scale_factor = 0.5
        # no_gaps_when_only = true
    }

    misc {
    #    layers_hog_keyboard_focus = 0
        #cursor_zoom_factor = 1.5
        #cursor_zoom_rigid = 1
    }

    # BLUR LAYERS
    blurls = rofi
    blurls = launcher
    blurls = waybar

    # WINDOW RULES
    # example window rules
    # for windows named/classed as abc and xyz
    #windowrule = move 69 420,abc
    #windowrule = size 420 69,abc
    #windowrule = tile,xyz
    #windowrule = float,^(qjack)(.*)$
    #windowrule = pseudo,abc
    #windowrule = monitor 0,xyz
    #windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

    windowrule = float,kvantummanager
    windowrule = float,org.gnome.Settings
    windowrule = float,Lxappearance
    windowrule = float,obs
    windowrule = float,zathura
    windowrule = float,feh
    windowrule = float,qemu
    #windowrule = float,DesktopEditors
    windowrule = float,biz.ntinfo.die
    windowrule = float,Ultimaker Cura
    windowrule = float,Pinentry-gtk-2
    windowrule = float,title:^(Ghidra:)(.*)$
    windowrulev2 = nofullscreenrequest,class:firefox,floating:1
    windowrulev2 = float,class:re.rizin.cutter,title:^(Open).*$
    windowrulev2 = float,class:re.rizin.cutter,title:^Load Options$
    windowrulev2 = stayfocused,class:^(ghidra-Ghidra)$,floating:1,fullscreen:0,initialTitle:^(CodeBrowser.*)$

    # KEY BINDINGS
    # Drag & resize windows with mouse
    bindm = SUPER,mouse:272,movewindow
    bindm = SUPER,mouse:273,resizewindow

    #Applications
    bind = SUPER,Return,exec,$terminal
    bind = SUPERSHIFT,Return,exec,$terminal ipython
    bind = SUPER,E,exec,dolphin
    bind = SUPER,B,exec,chromium

    # Screenshots
    $screenshot_dir = $HOME/media/picture/screenshots/
    bind = SUPERSHIFT,S,exec,filename=$(date +'%H%M%S_%a%d%h%y_sel') && grim -g "$(slurp)" "$screenshot_dir$filename.png" && wl-copy < "$screenshot_dir$filename.png" && notify-send "Screenshot takenm $filename.png"
    bind = SUPERCTRL,S,exec,filename=$(date +"%H%M%S_%a%d%h%y_full") && grim "$screenshot_dir$filename.png" && wl-copy < "$screenshot_dir$filename.png" && notify-send "Screenshot taken: $filename.png"

    # rofi menus
    bind = SUPER,D,exec,rofi -show drun -show-icons
    bind = ,Menu,exec,rofi -show drun -show-icons

    bind = SUPER,R,exec,rofi -show run -run-shell-command '{terminal} zsh -ic "{cmd} && read"'
    bind = SUPER,F,exec,rofi -show window -show-icons
    bind = SUPERSHIFT,P,exec,pass clip --rofi
    bind = SUPER,C,exec,pass clip --rofi
    bind = SUPER,V,exec,wlclipmgr restore -i "$(wlclipmgr list -l 100 | rofi -dmenu | awk '{print $1}')" &>> ~/.config/scripts/wlclipmgr/log

    # tofi menus
    #$tofi_theme = ~/.config/tofi/top_left
    #bind = SUPER,D,exec,tofi-drun --drun-launch=true --include $tofi_theme
    #bind = SUPER,R,exec,tofi-run --include $tofi_theme | xargs sh -c
    #bind = SUPERSHIFT,P,exec,$terminal fish -c "pass clip && sleep 1"
    #bind = SUPERSHIFT,R,exec,wlclipmgr restore -i "$(wlclipmgr list -l 100 | tofi --include $tofi_theme | awk '{print $1}')" &>> ~/.config/scripts/wlclipmgr/log

    # Window Manager
    bind = SUPERSHIFT,C,killactive,
    bind = SUPERSHIFT,Space,togglefloating,
    bind = SUPER,P,pseudo,
    bind = SUPER,M,fullscreen,
    bind = ALT,P,pin

    bind = SUPERSHIFT,E,exit,

    bind = SUPER,left,movefocus,l
    bind = SUPER,right,movefocus,r
    bind = SUPER,up,movefocus,u
    bind = SUPER,down,movefocus,d

    bind = SUPER,h,movefocus,l
    bind = SUPER,l,movefocus,r
    bind = SUPER,k,movefocus,u
    bind = SUPER,j,movefocus,d

    bind = SUPER,w,workspace,+1
    bind = SUPER,q,workspace,-1
    bind = SUPER,1,workspace,1
    bind = SUPER,2,workspace,2
    bind = SUPER,3,workspace,3
    bind = SUPER,4,workspace,4
    bind = SUPER,5,workspace,5
    bind = SUPER,6,workspace,6
    bind = SUPER,7,workspace,7
    bind = SUPER,8,workspace,8
    bind = SUPER,9,workspace,9
    bind = SUPER,0,workspace,10
    bind = SUPER,a,togglespecialworkspace

    bind = ALT,w,movetoworkspace,+1 # Monitor Num
    bind = ALT,q,movetoworkspace,-1 # Monitor Num
    bind = ALT,1,movetoworkspace,1
    bind = ALT,2,movetoworkspace,2
    bind = ALT,3,movetoworkspace,3
    bind = ALT,4,movetoworkspace,4
    bind = ALT,5,movetoworkspace,5
    bind = ALT,6,movetoworkspace,6
    bind = ALT,7,movetoworkspace,7
    bind = ALT,8,movetoworkspace,8
    bind = ALT,9,movetoworkspace,9
    bind = ALT,0,movetoworkspace,10
    bind = ALT,a,movetoworkspace,special # Seems to be broken

    bind = SUPERSHIFT,w,movetoworkspacesilent,+1 # Monitor Num
    bind = SUPERSHIFT,q,movetoworkspacesilent,-1 # Monitor Num
    bind = SUPERSHIFT,1,movetoworkspacesilent,1
    bind = SUPERSHIFT,2,movetoworkspacesilent,2
    bind = SUPERSHIFT,3,movetoworkspacesilent,3
    bind = SUPERSHIFT,4,movetoworkspacesilent,4
    bind = SUPERSHIFT,5,movetoworkspacesilent,5
    bind = SUPERSHIFT,6,movetoworkspacesilent,6
    bind = SUPERSHIFT,7,movetoworkspacesilent,7
    bind = SUPERSHIFT,8,movetoworkspacesilent,8
    bind = SUPERSHIFT,9,movetoworkspacesilent,9
    bind = SUPERSHIFT,0,movetoworkspacesilent,10
    bind = SUPERSHIFT,a,movetoworkspacesilent,special

    bind = SUPER,adiaeresis,swapnext
    bind = SUPER,odiaeresis,togglesplit

    bind = ALT,Space,togglegroup
    bind = ALT,j,changegroupactive,f
    bind = ALT,k,changegroupactive,b
    bind = ALT,c,togglesplit
    bind = CTRL , Alt_L, submap, passthrough
      submap = passthrough
    bind = CTRL , Alt_L, submap, reset
      submap = reset
  '';

  xdg.configFile."hypr/device.conf".text =
    if hostname == "desktop" then ''
      monitor = DP-2, 1280x1024@75.025, 640x0, 1
      monitor = HDMI-A-1, 1920x1080@60, 0x1024, 1
      monitor = DP-3, 1920x1080@144, 1920x597, 1

      # BIND WORKSPACES TO MONITORS
      workspace = DP-3,1
      workspace = HDMI-A-1,10
      workspace = DP-2,100

      input {
          kb_layout = de
          follow_mouse = 1
          natural_scroll = 0
          left_handed = 0
          kb_options = caps:swapescape
      }

      device:SONiX USB DEVICE {
          kb_layout = de
      }
    ''
    else if hostname == "vm" then ''
      monitor=Virtual-1,1920x1080@60,auto,1

      input {
          kb_layout = de
          follow_mouse = 1
          natural_scroll = 0
          left_handed = 0
      }
    ''
    else ''
    '';


  # TODO: Add device-laptop.conf here
  #
  xdg.configFile."hypr/hyprpaper.conf".text =
    if hostname == "desktop" then ''
      preload = ~/media/picture/walDP-3.png
      preload = ~/media/picture/walHDMI-A-1.png
      preload = ~/media/picture/walDP-2.png

      wallpaper = DP-3,~/media/picture/walDP-3.png
      wallpaper = HDMI-A-1,~/media/picture/walHDMI-A-1.png
      wallpaper = DP-2,~/media/picture/walDP-2.png
    ''
    else if hostname == "vm" then ''
      preload = ~/media/picture/walVirtual-1.png

      wallpaper = Virtual-1,~/media/picture/walVirtual-1.png
    ''
    else ''
    '';
}
