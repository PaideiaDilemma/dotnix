{
  inputs,
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

    niri.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable Niri";
    };

    default_session = mkOption {
      type = types.enum ["hyprland" "niri" "tuigreet" "shell"];
      default = "tuigreet";
      description = "Default session to start at startup";
    };
  };

  config = {
    programs.hyprland = {
      enable = cfg.hyprland.enable;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    services.greetd = {
      enable = true;
      vt = 2;
      settings = rec {
        hyprland_session = lib.mkIf (cfg.hyprland.enable) {
          user = "max";
          command = "$SHELL -l -c ${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland";
        };
        niri_session = lib.mkIf (cfg.niri.enable) {
          user = "max";
          command = "$SHELL -l -c ${inputs.niri.packages.${pkgs.system}.niri-unstable}/bin/niri-session";
        };
        shell_session = {
          user = "max";
          command = "$SHELL -l";
        };
        tuigreet_session = {
          user = "max";
          command = ''
            $SHELL -l -c "${pkgs.greetd.tuigreet}/bin/tuigreet \
              --sessions ${inputs.niri.packages.${pkgs.system}.niri-unstable}/share/wayland-sessions:${inputs.hyprland.packages.${pkgs.system}.hyprland}/share/wayland-sessions \
              --remember \
              --remember-user-session \
              --power-shutdown /run/current-system/systemd/bin/systemctl poweroff \
              --power-reboot /run/current-system/systemd/bin/systemctl reboot"
          '';
        };

        default_session =
          if cfg.default_session == "hyprland"
          then hyprland_session
          else if cfg.default_session == "niri"
          then niri_session
          else if cfg.default_session == "tuigreet"
          then tuigreet_session
          else shell_session;
      };
    };
  };
}
