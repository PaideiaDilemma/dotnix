{
  config,
  pkgs,
  lib,
  ...
}:
#pwndbg = pkgs.callPackage ./pwndbg.nix {};
#pwntools = pkgs.callPackage ./pwntools.nix { debugger = pwndbg; };
{
  home.packages = with pkgs; [
    gdb
    gef
    pwndbg
  ];

  home.file.".gdbinit".text = ''
    source ${config.xdg.configHome}/gdb/find_libc_start.py
    set debug-file-directory /tmp/gdb-symbols
  '';

  xdg.configFile."gdb/find_libc_start.py".source = ./find_libc_start.py;
}
