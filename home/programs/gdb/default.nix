{ config, pkgs, lib, ... }:
{
  home.packages = (with pkgs; [
    gdb
    pwndbg
    gef
  ]);

  home.file.".gdbinit".text = ''
    source ${config.xdg.configHome}/gdb/find_libc_start.py
  '';

  xdg.configFile."gdb/find_libc_start.py".source = ./find_libc_start.py;
}
