{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
}:
let
# TODO: Just use the flake and make some overrides
  gdb = pkgs.gdb;
  pythonPackages = pkgs.python311Packages;
  version = "bb4af280b0cc576d004bf8dc7b07d32ec54b54d5";

  pwndbgSrc = stdenv.mkDerivation {
    name = "pwndbg-patched";
    src = fetchFromGitHub {
      owner = "pwndbg";
      repo = "pwndbg";
      rev = version;
      hash = "sha256-Is/669FMfbOv2uy2AjsopWHgjkG2kcXMU3NnoAQoNZg=";
    };

    buildPhase = ''
      mkdir -p $out/
      cp -r * $out/
      # poetry.lock defines setuptools = "69.0.3" to fix capstone
      # but it is not in nixpkgs yet and the problem does not exist with nix.
      # https://github.com/pwndbg/pwndbg/pull/1946#issuecomment-1921603947
      #sed -i 's/^setuptools = \"69.0.3\"/setuptools = \"^69.0.2\"/' $out/pyproject.toml
    '';
  };

  # In the original flake, pwntools was specified here.
  # But it is already included in the pyEnv derivation.
  # It could be that pwndbg needs the pwn executable at runtime for some commands?
  # But I dont't think so.
  binPath = pkgs.lib.makeBinPath ([ ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    pythonPackages.ropper     # ref: https://github.com/pwndbg/pwndbg/blob/2023.07.17/pwndbg/commands/ropper.py#L30
    pythonPackages.ropgadget  # ref: https://github.com/pwndbg/pwndbg/blob/2023.07.17/pwndbg/commands/rop.py#L34
  ]);

  pyEnv = pkgs.poetry2nix.mkPoetryEnv {
    projectDir = pwndbgSrc;
    overrides = pkgs.poetry2nix.overrides.withDefaults (final: prev: {
      # pt failes with > ModuleNotFoundError: No module named 'poetry'
      pt = prev.pt.overridePythonAttrs (oldAttrs: {
        buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ prev.poetry-core ];
      });
      # unicorn has a view problems
      unicorn = pythonPackages.unicorn;
      # for some reason pwntools has pip in propagatedBuildInputs
      # maybe it installs packages at runtime?
      pwntools = prev.pwntools.overridePythonAttrs (oldAttrs: {
        propagatedBuildInputs = builtins.filter (x: (builtins.match "^python[0-9.]+-pip-[0-9.]+$" x.name) == null) oldAttrs.propagatedBuildInputs;
      });
    });
  };
in
pkgs.stdenv.mkDerivation {
  name = "pwndbg";
  version = version;

  src = pkgs.poetry2nix.cleanPythonSources {
    src = pwndbgSrc;
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/pwndbg

    cp -r gdbinit.py pwndbg $out/share/pwndbg

    ln -s ${pyEnv} $out/share/pwndbg/.venv

    makeWrapper ${gdb}/bin/gdb $out/bin/pwndbg \
      --add-flags "--quiet --early-init-eval-command=\"set charset UTF-8\" --early-init-eval-command=\"set auto-load safe-path /\" --command=$out/share/pwndbg/gdbinit.py" \
      --prefix PATH : ${binPath} \
      --set LC_CTYPE C.UTF-8
  '';

  meta = with lib; {
    description = "Exploit Development and Reverse Engineering with GDB Made Easy";
    homepage = "https://github.com/pwndbg/pwndbg";
    license = licenses.mit;
    # not supported on aarch64-darwin see: https://inbox.sourceware.org/gdb/3185c3b8-8a91-4beb-a5d5-9db6afb93713@Spark/
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
