{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.host;
in {
  options.host = {
    default_session = mkOption {
      type = types.enum ["hyprlock_login" "shell"];
      default = "hyprlock_login";
      description = "Default session to start at startup";
    };
  };

  config = {
    programs.hyprland = {
      enable = config.host.gui.enable;
      withUWSM = true;
    };

    services.greetd = {
      enable = true;
      vt = 2;
      settings = let
        hyprlock_config = pkgs.writeText "hyprlock_greet.conf" ''
          bezier=linear, 1, 1, 0, 0
          bezier=equal, 1, 0.5, 0, 0.5
          bezier=outCirc, 0.075, 0.82, 0.165, 1
          bezier=inCirc, 0.6, 0.04, 0.98, 0.335
          bezier=inOutCirc, 0.785, 0.135, 0.15, 0.86
          animation=fade, 1, 4, inCirc
          animation=inputFieldDots, 1, 2, linear
          animation=inputFieldFade, 1, 4, outCirc
          animation=inputFieldWidth, 1, 3, inOutCirc
          animation=inputFieldColors, 1, 6, linear

          background {
            monitor=
            blur_passes=0
            blur_size=10
            color=rgb(303338)
          }

          input-field {
            capslock_color=rgb(CB7459)
            check_color=rgb(46A473)
            dots_rounding=0
            dots_size=0.400000
            dots_spacing=0.100000
            dots_text_format=
            fade_timeout=4000
            fail_color=rgb(CB7459)
            font_color=rgb(8F8F8F)
            font_family=FiraMono Nerd Font Propo
            halign=center
            inner_color=rgba(FFF7ED00)
            monitor=
            outer_color=rgba(FFF7EDa0)
            outline_thickness=4
            placeholder_text=<i>$GREETDPROMPT</i>
            position=0, -20
            rounding=15
            size=250, 40
            valign=center
          }

          label {
            color=rgb(FFF7ED)
            font_family=Noto Sans
            font_size=40
            halign=center
            monitor=
            position=0, 100
            text=$TIME
            valign=center
          }

          label {
            color=rgba(BEBEBEA0)
            font_family=Noto Sans
            font_size=24
            halign=center
            monitor=
            position=0, 145
            text=cmd[update:10000] date '+%A %d %B %Y'
            valign=center
          }

          login {
            user = max
            #default_session=
          }

          login-session {
            name = Hyprland (debug)
            exec = ${pkgs.uwsm}/bin/uwsm start -N "Hyprland (debug)"  -- ${pkgs.hyprland-debug}/bin/Hyprland --config ~/.config/hypr/hyprland.conf
          }

          login-session {
            name = Hyprland (debug TRACE)
            exec = ${pkgs.uwsm}/bin/uwsm start -N "Hyprland (debug TRACE)"  -- HYPRLAND_TRACE=1 AQ_TRACE=1 ${pkgs.hyprland-debug}/bin/Hyprland --config ~/.config/hypr/hyprland.conf
          }

          session-picker {
            monitor=
            position=0, 1%
            size = 10%, 10%
            rounding=15
            halign=center
            valign=bottom
            inner_color = rgba(00000000)
            selected_color = rgba(00000000)
            selected_border_color=rgba(FFF7EDa0)
          }
        '';
        hyprland_config = pkgs.writeText "hyprland_greet.conf" ''
          animations {
            enabled=0
          }

          decoration {
            shadow {
                enabled=0
              }
            rounding=0
          }

          input {
            follow_mouse=1
            kb_layout=eu
            kb_options=caps:swapescape
            mouse_refocus=0
          }

          misc {
            disable_hyprland_logo=1
            disable_splash_rendering=1
            force_default_wallpaper=0
            key_press_enables_dpms=1
          }

          bind=SUPERSHIFT, E, exit
          exec-once=mkdir /tmp/greetd
          env=HOME,/tmp/greetd
          exec-once=${pkgs.hyprlock-greetd}/bin/hyprlock --config ${hyprlock_config} --greetd --session-dirs ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions/ > /tmp/hyprlock_greetd 2>&1
        '';
      in rec {
        shell_session = {
          command = "$SHELL -l";
        };
        hyprlock_login = {
          command = "${pkgs.hyprland}/bin/Hyprland --config ${hyprland_config} > /dev/null 2>&1";
        };

        default_session =
          if cfg.default_session == "hyprlock_login"
          then hyprlock_login
          else shell_session;
      };
    };
  };
}
