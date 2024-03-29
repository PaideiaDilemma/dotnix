{
  config,
  pkgs,
  ...
}: let
  colors = config.colors;
in {
  xdg.configFile."qt5ct/colors/Penumbra.conf".text = ''
      #               FG              BTN_BG bright less brdark        less da     txt fg               br text              btn fg           txt bg     bg     shadow   sel bg     sel fg     link       visited           alt bg default          tooltip bg  tooltip_fg
    [ColorScheme]
      active_colors=${colors.base.sun},          ${colors.base.shade}, ${colors.base.shade}, ${colors.base.shade}, ${colors.base.shade_}, ${colors.base.shade_}, ${colors.base.sun},           ${colors.base.sun},           ${colors.base.sun},           ${colors.base.sky_}, ${colors.base.shade}, ${colors.base.shade_}, ${colors.six.cyan}, ${colors.base.sun}, ${colors.six.cyan}, ${colors.base.sun},            ${colors.base.shade}, ${colors.base.sun},           ${colors.base.shade_},  ${colors.base.sun_}
    disabled_colors=#cbc6bf, ${colors.base.shade}, ${colors.base.shade}, ${colors.base.shade}, ${colors.base.shade_}, ${colors.base.shade_}, #d8d2ca,  #d8d2ca,  #cbc6bf,  ${colors.base.sky_}, ${colors.base.shade}, ${colors.base.shade_}, ${colors.six.cyan}, ${colors.base.sun}, ${colors.six.cyan}, #cbc6bf,   ${colors.base.shade}, #cbc6bf,  ${colors.base.shade_}, #beb6a9
    inactive_colors=${colors.base.sun},          ${colors.base.shade}, ${colors.base.shade}, ${colors.base.shade}, ${colors.base.shade_}, ${colors.base.shade_}, ${colors.base.sun},           ${colors.base.sun},           ${colors.base.sun},           ${colors.base.sky_}, ${colors.base.shade}, ${colors.base.shade_}, ${colors.six.cyan}, ${colors.base.sun}, ${colors.six.cyan}, ${colors.base.sun},            ${colors.base.shade}, ${colors.base.sun},           ${colors.base.shade_}, ${colors.base.sun_}

    #               FG              BTN_BG     bright   less br  dark     less da  txt fg               br text  btn fg     txt bg     bg     shadow   sel bg     sel fg     link       visite alt bg default  tooltip bg  tooltip_fg
    #  active_colors=${colors.base.sun},          ${colors.base.shade'}, ${colors.base.shade}, #cbc7c4, #9f9d9a, #b8b5b2, ${colors.base.sun},           #ff0000, ${colors.base.sun_}, ${colors.base.sky_}, ${colors.base.shade}, #767472, ${colors.six.cyan}, ${colors.base.sun}, ${colors.six.cyan}, ${colors.base.sun},            ${colors.base.shade}, ${colors.base.sun},           ${colors.base.shade_}, ${colors.base.sun_}
    #disabled_colors=#cbc6bf, ${colors.base.shade'}, ${colors.base.shade}, #cbc7c4, #9f9d9a, #b8b5b2, #d8d2ca,  #ffec17, ${colors.base.sun_}, ${colors.base.sky_}, ${colors.base.shade}, #767472, ${colors.six.cyan}, ${colors.base.sun}, ${colors.six.cyan}, #cbc6bf,   ${colors.base.shade}, #cbc6bf,  ${colors.base.shade_}, #beb6a9
    #inactive_colors=${colors.base.sun},          ${colors.base.shade'}, ${colors.base.shade}, #cbc7c4, #9f9d9a, #b8b5b2, ${colors.base.sun},           #ff9040, ${colors.base.sun_}, ${colors.base.sky_}, ${colors.base.shade}, #767472, ${colors.six.cyan}, ${colors.base.sun}, ${colors.six.cyan}, ${colors.base.sun},            ${colors.base.shade}, ${colors.base.sun},           ${colors.base.shade_}, ${colors.base.sun_}

  '';

  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    color_scheme_path=${config.xdg.configHome}/qt5ct/colors/Penumbra.conf
    custom_palette=true
    icon_theme=Penumbra
    standard_dialogs=default
    style=Fusion

    [Fonts]
    fixed="Fira Code,12,-1,5,50,0,0,0,0,0"
    general="Noto Sans,11,-1,5,50,0,0,0,0,0"
  '';

  xdg.configFile."qt6ct/colors/Penumbra.conf".text = ''
      #               FG              BTN_BG bright less brdark        less da     txt fg               br text              btn fg           txt bg     bg     shadow   sel bg     sel fg     link       visited           alt bg default          tooltip bg  tooltip_fg	placeholder_fg
    [ColorScheme]
    active_colors=${colors.base.sun},          ${colors.base.shade}, ${colors.base.shade}, ${colors.base.shade}, ${colors.base.shade_}, ${colors.base.shade_}, ${colors.base.sun},           ${colors.base.sun},           ${colors.base.sun},           ${colors.base.sky_}, ${colors.base.shade}, ${colors.base.shade_}, ${colors.six.cyan}, ${colors.base.sun}, ${colors.six.cyan}, ${colors.base.sun},            ${colors.base.shade}, ${colors.base.sun},           ${colors.base.shade_},  ${colors.base.sun_}, #cbc6bf
    disabled_colors=#cbc6bf, ${colors.base.shade}, ${colors.base.shade}, ${colors.base.shade}, ${colors.base.shade_}, ${colors.base.shade_}, #d8d2ca,  #d8d2ca,  #cbc6bf,  ${colors.base.sky_}, ${colors.base.shade}, ${colors.base.shade_}, ${colors.six.cyan}, ${colors.base.sun}, ${colors.six.cyan}, #cbc6bf,   ${colors.base.shade}, #cbc6bf,  ${colors.base.shade_}, #beb6a9,  #cbc6bf
    inactive_colors=${colors.base.sun},          ${colors.base.shade}, ${colors.base.shade}, ${colors.base.shade}, ${colors.base.shade_}, ${colors.base.shade_}, ${colors.base.sun},           ${colors.base.sun},           ${colors.base.sun},           ${colors.base.sky_}, ${colors.base.shade}, ${colors.base.shade_}, ${colors.six.cyan}, ${colors.base.sun}, ${colors.six.cyan}, ${colors.base.sun},            ${colors.base.shade}, ${colors.base.sun},           ${colors.base.shade_}, ${colors.base.sun_}, #cbc6bf
  '';

  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    color_scheme_path=${config.xdg.configHome}/qt6ct/colors/Penumbra.conf
    custom_palette=true
    icon_theme=Penumbra
    standard_dialogs=xdgdesktopportal
    style=Fusion

    [Fonts]
    fixed="Fira Code,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    general="Fira Sans,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
  '';
}
