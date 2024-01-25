{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.hyprhome;
  wlclipmgr = pkgs.stdenv.mkDerivation {
    name = "wlclipmgr";
    src = pkgs.fetchFromGitHub {
      owner = "PaideiaDilemma";
      repo = "wlclipmgr";
      rev = "d5dadc1b00376e381172263df39e54af04cc70f9";
      fetchSubmodules = true;
      hash = "sha256-JvUgDqSfGGqWVVI8qOmEGeF0FKTC8PgHhjhMMsPS9Mw=";
    };

    nativeBuildInputs = with pkgs; [
      meson
      pkg-config
      cmake
      ninja
      boost
      msgpack-cxx
      gpgme
      libgpg-error
      magic-enum
      procps
    ];

    buildPhase = ''
      mkdir -p build
      meson setup build $src --buildtype release
      meson compile -C build
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp build/wlclipmgr $out/bin
    '';
  };
in
{
  options.hyprhome.wlclipmgr = {
    enable = mkOption {
      default = true;
      description = "Whether to enable the wlclipmgr.";
      type = types.bool;
    };
  };

  config = mkIf (cfg.gui.enable && cfg.wlclipmgr.enable) {
    home.packages = [
      wlclipmgr
    ];
  };
}
