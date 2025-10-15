{config, ...}: let
  cfg = config.hyprhome;
in {
  systemd.user.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    NVIM_APPNAME = "nvim-minimax";
    BROWSER = "firefox";
    TERMINAL = "${cfg.terminal}";
    TERM_PROGRAM = "${cfg.terminal}";

    _JAVA_AWT_WM_NONREPARENTING = "1";

    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

    MOZ_ENABLE_WAYLAND = "1";
    CLUTTER_BACKEND = "wayland";

    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";

    HYPRCURSOR_THEME = "DeepinV20HyprCursors";
    HYPRCURSOR_SIZE = "32";
    GNUPGHOME = "${config.xdg.configHome}/gnupg";
  };
}
