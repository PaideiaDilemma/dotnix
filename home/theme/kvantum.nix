{
  config,
  lib,
  pkgs,
  ...
}: let
  colors = config.colors;

  arcDarkSource = pkgs.fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "arc-kde";
    rev = "20220908";
    hash = "sha256-dxk8YpJB4XaZHD/O+WvQUFKJD2TE38VZyC5orn4N7BA=";
  };

  modifiedKvconfig =
    pkgs.stdenv.mkDerivation
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
          --replace "window.color=#353945" "window.color=${colors.base.shade_}" \
          --replace "base.color=#404552" "base.color=${colors.base.shade}" \
          --replace "alt.base.color=#404552" "alt.base.color=${colors.base.shade}" \
          --replace "button.color=#444a58" "button.color=${colors.base.shade'}" \
          --replace "light.color=#404552" "light.color=${colors.base.sky_}" \
          --replace "mid.light.color=#404552" "mid.light.color=${colors.base.shade'}" \
          --replace "dark.color=#2F343f" "dark.color=${colors.base.shade_}" \
          --replace "mid.color=#2F343f" "mid.color=${colors.base.shade}" \
          --replace "highlight.color=#5294E2" "highlight.color=${colors.accent.blue}" \
          --replace "inactive.highlight.color=#5294E2" "inactive.highlight.color=${colors.accent.blue}"ß \
          --replace "text.color=#d3dae3" "text.color=${colors.base.sun}" \
          --replace "window.text.color=#d3dae3" "window.text.color=${colors.base.sun}" \
          --replace "button.text.color=#d3dae3" "button.text.color=${colors.base.sun_}" \
          --replace "disabled.text.color=#898d99" "disabled.text.color=${colors.base.sky}" \
          --replace "tooltip.text.color=#d3dae3" "tooltip.text.color=${colors.base.sun}" \
          --replace "highlight.text.color=#d3dae3" "highlight.text.color=${colors.base.sun}" \
          --replace "link.color=#1d99f3" "link.color=${colors.accent.cyan}" \
          --replace "link.visited.color=#9b59b6" "link.visited.color=${colors.accent.blue}" \

        sed -i " \
          s/#ffffff/#FFFFFF/g; \
          s/#d3dae3/${colors.base.sun_}/g; \
          s/#898d99/${colors.base.sky}/g; \
          s/#5294e2/${colors.accent.blue}/g;" $out/Penumbra.kvconfig
      '';
    };

  modifiedSvg =
    pkgs.stdenv.mkDerivation
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
          s/#5294e2/${colors.accent.blue}/g; \
          s/#2f343f/${colors.base.shade'}/g; \
          s/#444a58/${colors.base.sky_}/g; \
          s/#505666/${colors.base.sky_}/g; \
          s/#272a33/${colors.base.shade}/g; \
          s/#b3b3b3/${colors.base.sky}/g; \
          s/#aaaaaa/${colors.base.sky}/g; \
          s/#aaa/${colors.base.sky}/g; \
          s/#505766/${colors.base.shade}/g; \
          s/#383c4a/${colors.base.shade}/g; \
          s/#2d323d/${colors.base.sky_}/g; \
          s/#2b303b/${colors.base.sky_}/g; \
          s/#262934/${colors.base.shade}/g; \
          s/#ff4d4d/${colors.accent.red}/g; \
          s/#4877b1/#5794D0/g; \
          s/#414857/${colors.base.shade}/g; \
          s/#353945/${colors.base.shade}/g;" $out/Penumbra.svg
      '';
    };
in {
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Penumbra
  '';

  xdg.configFile."Kvantum/Penumbra/Penumbra.kvconfig".source = modifiedKvconfig + "/Penumbra.kvconfig";
  xdg.configFile."Kvantum/Penumbra/Penumbra.svg".source = modifiedSvg + "/Penumbra.svg";
}
