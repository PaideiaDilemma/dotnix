{ config, lib, pkgs, ... }:

let
  arcDarkSource = pkgs.fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "arc-kde";
    rev = "20220908";
    hash = "sha256-dxk8YpJB4XaZHD/O+WvQUFKJD2TE38VZyC5orn4N7BA=";
  };

  modifiedKvconfig = pkgs.stdenv.mkDerivation
    {
      name = "penumbra-kvconfig";
      src = arcDarkSource + "/Kvantum/ArcDark/";
      dontUnpack = true;
      dontBuild = true;
      dontConfigure = true;
      installPhase = ''
        mkdir -p $out
        cp $src/LICENSE $out/LICENSE
        cp $src/ArcDark.kvconfig $out/Penumbra.kvconfig

        substituteInPlace $out/Penumbra.kvconfig \
          --replace "translucent_windows=true" "translucent_windows=false" \
          --replace "blurring=true" "blurring=false" \
          --replace "popup_blurring=true" "popup_blurring=false" \
          --replace "window.color=#353945" "window.color=#24272B" \
          --replace "base.color=#404552" "base.color=#303338" \
          --replace "alt.base.color=#404552" "alt.base.color=#303338" \
          --replace "button.color=#444a58" "button.color=#3E4044" \
          --replace "light.color=#404552" "light.color=#636363" \
          --replace "mid.light.color=#404552" "mid.light.color=#3E4044" \
          --replace "dark.color=#2F343f" "dark.color=#24272B" \
          --replace "mid.color=#2F343f" "mid.color=#303338" \
          --replace "highlight.color=#5294E2" "highlight.color=#7E87D6" \
          --replace "inactive.highlight.color=#5294E2" "inactive.highlight.color=#7E87D6"ß \
          --replace "text.color=#d3dae3" "text.color=#FFF7ED" \
          --replace "window.text.color=#d3dae3" "window.text.color=#FFF7ED" \
          --replace "button.text.color=#d3dae3" "button.text.color=#F2E6D4" \
          --replace "disabled.text.color=#898d99" "disabled.text.color=#8F8F8F" \
          --replace "tooltip.text.color=#d3dae3" "tooltip.text.color=#FFF7ED" \
          --replace "highlight.text.color=#d3dae3" "highlight.text.color=#FFF7ED" \
          --replace "link.color=#1d99f3" "link.color=#00A0BE" \
          --replace "link.visited.color=#9b59b6" "link.visited.color=#7E87D6" \

        sed -i " \
          s/#ffffff/#FFFFFF/g; \
          s/#d3dae3/#F2E6D4/g; \
          s/#898d99/#8F8F8F/g; \
          s/#5294e2/#7E87D6/g;" $out/Penumbra.kvconfig
      '';
    };

  modifiedSvg = pkgs.stdenv.mkDerivation
    {
      name = "penumbra-kvsvg";
      src = arcDarkSource + "/Kvantum/ArcDark/";
      dontUnpack = true;
      dontBuild = true;
      dontConfigure = true;
      installPhase = ''
        mkdir -p $out
        cp $src/LICENSE $out/LICENSE
        cp $src/ArcDark.svg $out/Penumbra.svg

        sed -i " \
          s/#5294e2/#7E87D6/g; \
          s/#2f343f/#3E4044/g; \
          s/#444a58/#636363/g; \
          s/#505666/#636363/g; \
          s/#272a33/#303338/g; \
          s/#b3b3b3/#8F8F8F/g; \
          s/#aaaaaa/#8F8F8F/g; \
          s/#aaa/#8F8F8F/g; \
          s/#505766/#303338/g; \
          s/#383c4a/#303338/g; \
          s/#2d323d/#636363/g; \
          s/#2b303b/#636363/g; \
          s/#262934/#303338/g; \
          s/#ff4d4d/#CB7459/g; \
          s/#4877b1/#5794D0/g; \
          s/#414857/#303338/g; \
          s/#353945/#303338/g;" $out/Penumbra.svg
      '';
    };
in
{
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Penumbra
  '';

  xdg.configFile."Kvantum/Penumbra/Penumbra.kvconfig".source = modifiedKvconfig + "/Penumbra.kvconfig";
  xdg.configFile."Kvantum/Penumbra/Penumbra.svg".source = modifiedSvg + "/Penumbra.svg";
}
