{
  lib,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.ghidra
    #(pkgs.ghidra.withExtensions (_: [
    #  (let
    #    pypkgs = pkgs.python3Packages;
    #    pyenv = pypkgs.python.withPackages (_: [pypkgs.binsync pypkgs.pyside6]);
    #    sitePkgs = "${pyenv}/lib/${pyenv.libPrefix}/site-packages";
    #  in
    #    pkgs.ghidra.buildGhidraScripts {
    #      pname = "ghidra-binsync";
    #      inherit (pypkgs.binsync) version;

    #      dontUnpack = true;
    #      buildPhase = ''
    #        cp ${sitePkgs}/binsync/binsync_plugin.py binsync_plugin.py
    #        ln -s ${sitePkgs}/libbs/decompiler_stubs/ghidra_libbs/{libbs_vendored,ghidra_libbs.py,ghidra_libbs_shutdown.py} .
    #        sed -i ${lib.escapeShellArg "s#binsync -s ghidra#${lib.getExe' pyenv "binsync"} -s ghidra#"} binsync_plugin.py
    #      '';
    #    })
    #]))
  ];
}
