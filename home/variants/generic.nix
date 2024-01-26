{ ... }:
{
  hyprhome = {
    gui.enable = true;
    hyprland = {
      enable = true;
      isVirtualMachine = true;
      enableAnimations = false;
      # When not specifing a monitor, the wallpaper will
      # be the same on every boot.
      monitors = { };
    };
  };
}
