{ inputs, config, lib, pkgs, ... }:
{
  imports = [
    ./fonts
    ./virtualisation
    ./services
  ];

  programs = {
    dconf.enable = true;
    git.enable = true;
    zsh.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };
}
