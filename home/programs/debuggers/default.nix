{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    gdb
    gef
    pwndbg
    pwndbg-lldb
  ];
}
