{ inputs, config, lib, pkgs, ... }:
{
  imports = [
    ./fonts
    ./virtualisation
    ./services
  ];

  programs.dconf.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };
}
