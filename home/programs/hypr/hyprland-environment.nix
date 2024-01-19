{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
      EDITOR = "nvim";
      NVIM_APPNAME = "lazyvim";
      BROWSER = "firefox";
      TERMINAL = "wezterm";
      GNUPGHOME = "$HOME/.config/gnupg/";
      PASSWORD_STORE_DIR = "$HOME/.config/pass";
      #__GLX_VENDOR_LIBRARY_NAME= "nvidia";
      #LIBVA_DRIVER_NAME= "nvidia"; # hardware acceleration
      #__GL_VRR_ALLOWED="1";
      WLR_NO_HARDWARE_CURSORS = "1"; # TODO: make this conditional
      WLR_RENDERER_ALLOW_SOFTWARE = "1"; # TODO: make this conditional
      CLUTTER_BACKEND = "wayland";
      #WLR_RENDERER = "vulkan";

      #XCURSOR_SIZE = "24";
      #XCURSOR_THEME = "PearWhiteCursors";

      _JAVA_AWT_WM_NONREPARENTING = "1";

      #QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      #QT_QPA_PLATFORM = "wayland;xcb";
      #QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      MOZ_ENABLE_WAYLAND = "1";

      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
