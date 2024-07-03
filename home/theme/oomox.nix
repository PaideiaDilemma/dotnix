{
  config,
  lib,
  pkgs,
  colors,
  ...
}:
with lib; let
  cfg = config.hyprhome;
  removeHash = str: lib.removePrefix "#" str;
  oomoxPatch = {
    name,
    installPhase,
  }:
    with pkgs;
      stdenv.mkDerivation rec {
        inherit name;
        src = fetchFromGitHub {
          owner = "themix-project";
          repo = "themix-gui";
          rev = "c1e0d5a7b8c227eda717faebf74b1ffa72c15058";
          hash = "sha256-OTTD/ArwPLtzaxCHcJrW19B0EgurmHCc4g/iJXigCD0=";
          fetchSubmodules = true;
        };

        buildPhase = ''
          mkdir -p $out/colors
          echo "
          ACCENT_BG=${removeHash colors.six.blue}
          BASE16_GENERATE_DARK=False
          BASE16_INVERT_TERMINAL=False
          BASE16_MILD_TERMINAL=False
          BG=${removeHash colors.base.shade}
          BTN_BG=${removeHash colors.base.shade'}
          BTN_FG=${removeHash colors.base.sun_}
          BTN_OUTLINE_OFFSET=-3
          BTN_OUTLINE_WIDTH=1
          CARET1_FG=${removeHash colors.base.sky}
          CARET2_FG=${removeHash colors.base.sky_}
          CARET_SIZE=0.04
          CINNAMON_OPACITY=1.0
          FG=${removeHash colors.base.sun}
          GRADIENT=0.0
          GTK3_GENERATE_DARK=False
          HDR_BG=${removeHash colors.base.shade_}
          HDR_BTN_BG=${removeHash colors.base.shade'}
          HDR_BTN_FG=${removeHash colors.base.sun_}
          HDR_FG=${removeHash colors.base.sun_}
          ICONS_ARCHDROID=dddddd
          ICONS_DARK=${removeHash colors.base.shade_}
          ICONS_LIGHT=5294e2
          ICONS_LIGHT_FOLDER=${removeHash colors.base.sky'}
          ICONS_MEDIUM=${removeHash colors.six.green}
          ICONS_NUMIX_STYLE=0
          ICONS_STYLE=papirus_icons
          ICONS_SYMBOLIC_ACTION=${removeHash colors.base.sun_}
          ICONS_SYMBOLIC_PANEL=${removeHash colors.base.sun_}
          MATERIA_PANEL_OPACITY=0.6
          MATERIA_SELECTION_OPACITY=0.32
          MATERIA_STYLE_COMPACT=False
          MENU_BG=${removeHash colors.base.shade}
          MENU_FG=${removeHash colors.base.sky'}
          NAME="penumbra"
          OUTLINE_WIDTH=1
          ROUNDNESS=7
          SEL_BG=${removeHash colors.six.cyan}
          SEL_FG=${removeHash colors.base.sun}
          SPACING=3
          SPOTIFY_PROTO_BG=${removeHash colors.base.shade}
          SPOTIFY_PROTO_FG=${removeHash colors.base.sun}
          SPOTIFY_PROTO_SEL=${removeHash colors.six.cyan}
          SURUPLUS_GRADIENT1=${removeHash colors.base.sky'}
          SURUPLUS_GRADIENT2=${removeHash colors.six.blue}
          SURUPLUS_GRADIENT_ENABLED=False
          TERMINAL_ACCENT_COLOR=${removeHash colors.six.blue}
          TERMINAL_BACKGROUND=${removeHash colors.base.shade}
          TERMINAL_BASE_TEMPLATE=tempus_summer
          TERMINAL_COLOR0=${removeHash colors.base.sky_}
          TERMINAL_COLOR1=${removeHash colors.six.red}
          TERMINAL_COLOR10=${removeHash colors.six'.green}
          TERMINAL_COLOR11=${removeHash colors.six'.yellow}
          TERMINAL_COLOR12=${removeHash colors.six'.blue}
          TERMINAL_COLOR13=${removeHash colors.six'.magenta}
          TERMINAL_COLOR14=${removeHash colors.six'.cyan}
          TERMINAL_COLOR15=${removeHash colors.base.sun_}
          TERMINAL_COLOR2=${removeHash colors.six.green}
          TERMINAL_COLOR3=${removeHash colors.six.yellow}
          TERMINAL_COLOR4=${removeHash colors.six.blue}
          TERMINAL_COLOR5=${removeHash colors.six.magenta}
          TERMINAL_COLOR6=${removeHash colors.six.cyan}
          TERMINAL_COLOR7=${removeHash colors.base.sun'}
          TERMINAL_COLOR8=${removeHash colors.base.sky}
          TERMINAL_COLOR9=${removeHash colors.six'.red}
          TERMINAL_CURSOR=${removeHash colors.base.sun_}
          TERMINAL_FOREGROUND=${removeHash colors.base.sun}
          TERMINAL_THEME_ACCURACY=128
          TERMINAL_THEME_AUTO_BGFG=False
          TERMINAL_THEME_EXTEND_PALETTE=False
          TERMINAL_THEME_MODE=manual
          THEME_STYLE=oomox
          TXT_BG=${removeHash colors.base.sky_}
          TXT_FG=${removeHash colors.base.sun}
          UNITY_DEFAULT_LAUNCHER_STYLE=False
          WM_BORDER_FOCUS=${removeHash colors.base.sun}
          WM_BORDER_UNFOCUS=${removeHash colors.base.sun_}
          " > $out/colors/penumbra.colors
        '';

        nativeBuildInputs = [glib libxml2 bc];
        buildInputs = [gnome3.gnome-themes-extra gdk-pixbuf librsvg pkgs.sassc pkgs.inkscape pkgs.optipng fontconfig];
        propagatedUserEnvPkgs = [gtk-engine-murrine];
        inherit installPhase;
      };
in {
  penumbra-oomox-icons = oomoxPatch {
    name = "penumbra-oomox-icons";
    installPhase = ''
      mkdir -p $out/share/icons/Penumbra
      pushd plugins/icons_papirus
      patchShebangs .
      ./change_color.sh -o Penumbra -d $out/share/icons/Penumbra $out/colors/penumbra.colors
      popd
    '';
  };

  penumbra-oomox-gtk = oomoxPatch {
    name = "penumbra-oomox-gtk";
    installPhase = ''
      mkdir -p $out/share/themes/Penumbra
      pushd plugins/theme_oomox
      patchShebangs .

      HOME=$out ./change_color.sh -o Penumbra -m all -t $out/share/themes $out/colors/penumbra.colors

      echo "
      /* remove window title from Client-Side Decorations */
      .solid-csd headerbar .title {
        font-size: 0;
      }

      /* hide extra window decorations/double border */
      window decoration {
        margin: 0;
        border: none;
        padding: 0;
      }

      button:disabled:disabled, button.flat:disabled:disabled {
        color: ${colors.base.sky};
      }" | tee -a $out/share/themes/Penumbra/gtk-3.0/gtk.css $out/share/themes/Penumbra/gtk-3.20/gtk.css
      popd
    '';
  };
}
