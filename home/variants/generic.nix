{ ... }:
{
  hyprhome = {
    # When not specifing a monitor, the wallpaper will
    # be the same on every boot.
    gui = {
      enable = true;
      monitors = {};
    };

    hyprland = {
      enable = true;
      isVirtualMachine = true;
      enableAnimations = false;
    };
  };
}
