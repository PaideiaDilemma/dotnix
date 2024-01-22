{ pkgs, lib, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      vim_keys = true;
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
    };
  };
}
