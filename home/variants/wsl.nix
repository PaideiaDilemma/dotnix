{ ... }:
{
  imports = [
    ../default.nix
  ];

  hyprhome = {
    gui.enable = false;
    hyprland = {
      enable = false;
    };
  };
}
