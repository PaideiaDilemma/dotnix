{ config, lib, pkgs, ... }:

let
  oomoxPatch = { name, installPhase }: with pkgs; stdenv.mkDerivation rec {
    inherit name;
    src = fetchFromGitHub {
      owner = "themix-project";
      repo = "themix-gui";
      rev = "1.15.1";
      hash = "sha256-xFtwNx1c7Atb+9yorZhs/uVkkoxbZiELJ0SZ88L7KMs=";
      fetchSubmodules = true;
    };

    buildPhase = ''
      mkdir -p $out/colors
      echo "
      ACCENT_BG=7E87D6
      BASE16_GENERATE_DARK=False
      BASE16_INVERT_TERMINAL=False
      BASE16_MILD_TERMINAL=False
      BG=303338
      BTN_BG=3E4044
      BTN_FG=F2E6D4
      BTN_OUTLINE_OFFSET=-3
      BTN_OUTLINE_WIDTH=1
      CARET1_FG=8F8F8F
      CARET2_FG=636363
      CARET_SIZE=0.04
      CINNAMON_OPACITY=1.0
      FG=FFF7ED
      GRADIENT=0.0
      GTK3_GENERATE_DARK=False
      HDR_BG=24272B
      HDR_BTN_BG=3E4044
      HDR_BTN_FG=F2E6D4
      HDR_FG=F2E6D4
      ICONS_ARCHDROID=dddddd
      ICONS_DARK=24272B
      ICONS_LIGHT=5294e2
      ICONS_LIGHT_FOLDER=BEBEBE
      ICONS_MEDIUM=46A473
      ICONS_NUMIX_STYLE=0
      ICONS_STYLE=papirus_icons
      ICONS_SYMBOLIC_ACTION=F2E6D4
      ICONS_SYMBOLIC_PANEL=F2E6D4
      MATERIA_PANEL_OPACITY=0.6
      MATERIA_SELECTION_OPACITY=0.32
      MATERIA_STYLE_COMPACT=False
      MENU_BG=303641
      MENU_FG=d3dae3
      NAME="penumbra"
      OUTLINE_WIDTH=1
      ROUNDNESS=7
      SEL_BG=00A0BE
      SEL_FG=FFF7ED
      SPACING=3
      SPOTIFY_PROTO_BG=303338
      SPOTIFY_PROTO_FG=FFF7ED
      SPOTIFY_PROTO_SEL=00A0BE
      SURUPLUS_GRADIENT1=d3dae3
      SURUPLUS_GRADIENT2=5294e2
      SURUPLUS_GRADIENT_ENABLED=False
      TERMINAL_ACCENT_COLOR=5294e2
      TERMINAL_BACKGROUND=303338
      TERMINAL_BASE_TEMPLATE=tempus_summer
      TERMINAL_COLOR0=636363
      TERMINAL_COLOR1=CB7459
      TERMINAL_COLOR10=5fbd8c
      TERMINAL_COLOR11=bca846
      TERMINAL_COLOR12=70ade9
      TERMINAL_COLOR13=d68bc1
      TERMINAL_COLOR14=19bbc8
      TERMINAL_COLOR15=ffffed
      TERMINAL_COLOR2=46A473
      TERMINAL_COLOR3=A38F2D
      TERMINAL_COLOR4=5794D0
      TERMINAL_COLOR5=BD72A8
      TERMINAL_COLOR6=00A2AF
      TERMINAL_COLOR7=FFFDFB
      TERMINAL_COLOR8=8F8F8F
      TERMINAL_COLOR9=e48d72
      TERMINAL_CURSOR=F2E6D4
      TERMINAL_FOREGROUND=FFF7ED
      TERMINAL_THEME_ACCURACY=128
      TERMINAL_THEME_AUTO_BGFG=False
      TERMINAL_THEME_EXTEND_PALETTE=False
      TERMINAL_THEME_MODE=manual
      THEME_STYLE=oomox
      TXT_BG=636363
      TXT_FG=FFF7ED
      UNITY_DEFAULT_LAUNCHER_STYLE=False
      WM_BORDER_FOCUS=FFF7ED
      WM_BORDER_UNFOCUS=F2E6D4
      " > $out/colors/penumbra.colors
    '';

    nativeBuildInputs = [ glib libxml2 bc ];
    buildInputs = [ gnome3.gnome-themes-extra gdk-pixbuf librsvg pkgs.sassc pkgs.inkscape pkgs.optipng ];
    propagatedUserEnvPkgs = [ gtk-engine-murrine ];
    inherit installPhase;
  };

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
      }" >> $out/share/themes/Penumbra/gtk-3.0/gtk.css
      popd
    '';
  };
in
{
  penumbra-oomox-icons = penumbra-oomox-icons;
  penumbra-oomox-gtk = penumbra-oomox-gtk;

  xdg.configFile."oomox/colors/penumbra".source = penumbra-oomox-gtk + "/colors/penumbra.colors";
}
