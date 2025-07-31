{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    #pkgs.pkgs.writeShellScriptBin "pwntools-gdb" ''
    #  exec ${pwndbg}/bin/pwndbg "$@"
    #''
    gdb
    gef
    pwndbg
    pwndbg-lldb
  ];
}
