{
  config,
  lib,
  pkgs,
  ...
}: let
  tabler-icons = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "tabler-icons";
    version = "3.35.0";

    src = pkgs.fetchzip {
      url = "https://registry.npmjs.org/@tabler/icons-webfont/-/icons-webfont-${version}.tgz";
      sha256 = "sha256-T3MjZTGBXVaDOWlfFdcWMD/YZkb8TouSeiKQBvz78a8=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/share/fonts/"{ttf,woff,woff2}
      ls -alh .
      cp dist/fonts/tabler-icons.ttf "$out/share/fonts/ttf/"
      cp dist/fonts/tabler-icons.woff "$out/share/fonts/woff/"
      cp dist/fonts/tabler-icons.woff2 "$out/share/fonts/woff2/"

      runHook postInstall
    '';

    meta = with lib; {
      description = "Tabler icons font";
      longDescription = '''';
      homepage = "https://tabler.io/icons";
      license = licenses.mit;
      platforms = platforms.all;
      maintainer = [];
    };
  };
in {
  fonts = {
    packages = with pkgs; [
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      open-sans
      tabler-icons
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Serif"];
        sansSerif = ["Noto Sans"];
      };
    };
  };
}
