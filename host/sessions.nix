{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.host;
in {
  options.host = {
    hyprland.enable = mkOption {
      type = types.bool;
      default = config.host.gui.enable;
      description = "Whether to enable Hyprland";
    };

    default_session = mkOption {
      type = types.enum ["hyprlock_login" "shell"];
      default = "hyprlock_login";
      description = "Default session to start at startup";
    };
  };

  config = {
    programs.hyprland = {
      enable = cfg.hyprland.enable;
    };

    services.greetd = {
      enable = true;
      vt = 2;
      settings = let
        hyprlock_config = pkgs.writeText "hyprlock_greet.conf" ''
          background {
            monitor=
            blur_passes=2
            blur_size=10
            color=rgb(303338)
            path=screenshot
          }

          login {
            user = max
          }

          login-session {
            name = Hyprland
            exec = Hyprland
          }

          login-session {
            name = Hyprland (Debug)
            exec = Hyprlandd
          }

          session-picker {
            monitor=
            position=0, 1%
            size = 10%, 10%
            rounding = 10
            halign=center
            valign=bottom
          }

          animations {
              enabled=true
              bezier=linear,1,1,0,0
              animation=global,1,6,"linear"
          }

          general {
            grace=10
            hide_cursor=true
          }

          input-field {
            monitor=
            size=50, 50
            capslock_color=rgb(CB7459)
            dots_rounding=0
            dots_size=0.35
            dots_spacing=0.1
            dots_text_format=*
            fade_on_empty=false
            font_color=rgb(8F8F8F)
            font_family=Noto Sans
            inner_color=rgba(00000000)
            outer_color=rgba(33ccff88) rgba(00ff9988) 45deg
            check_color=rgba(33ccffee) rgba(00ff99ee) 405deg
            fail_color=rgba(ff6633ee) rgba(ff0066ee) 45deg
            outline_thickness=4
            placeholder_text=<span font_family="Noto Sans">$PROMPT</span>
            fail_text=<span font_family="Noto Sans">$FAIL <b>($ATTEMPTS)</b></span>
            position=0, -5%
            rounding=-1
            halign=center
            valign=center
          }

          label {
            monitor=
            color=rgb(FFF7ED)
            font_family=Noto Sans
            font_size=40
            position=0, 10%
            text=Current user: $USER
            halign=center
            valign=center
          }

          label {
            monitor=
            color=rgba(BEBEBEA0)
            font_family=Noto Sans
            font_size=24
            position=0, 15%
            text=cmd[update:10000] date '+%A %d %B %Y'
            halign=center
            valign=center
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
            kb_options =caps:swapescape
            mouse_refocus=0
          }

          misc {
            disable_hyprland_logo=1
            disable_splash_rendering=1
            force_default_wallpaper=0
            key_press_enables_dpms=1
          }

          bind=SUPER,Return,exec,foot
          bind=SUPERSHIFT,E,exit,
          exec-once=${pkgs.hyprlock}/bin/hyprlock --config ${hyprlock_config} --greetd&
        '';
      in rec {
        shell_session = {
          command = "$SHELL -l";
        };
        hyprlock_login = {
          user = "max";
          command = ''$SHELL -l -c "${pkgs.hyprland}/bin/Hyprland --config ${hyprland_config}"'';
        };

        default_session =
          if cfg.default_session == "hyprlock_login"
          then hyprlock_login
          else shell_session;
      };
    };
  };
}
