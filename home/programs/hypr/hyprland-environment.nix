{ ... }:

{
  home = {
    sessionVariables = {
      NVIM_APPNAME = "lazyvim";
      BROWSER = "firefox";
      TERMINAL = "wezterm";

      WLR_RENDERER = "vulkan";

      #XCURSOR_SIZE = "24";
      #XCURSOR_THEME = "PearWhiteCursors";

      _JAVA_AWT_WM_NONREPARENTING = "1";

      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      MOZ_ENABLE_WAYLAND = "1";
      CLUTTER_BACKEND = "wayland";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      #PASSWORD_STORE_DIR = "$HOME/.config/pass";

      #__GLX_VENDOR_LIBRARY_NAME= "nvidia";
      #LIBVA_DRIVER_NAME= "nvidia"; # hardware acceleration
      #__GL_VRR_ALLOWED="1";
    };
  };
}
