{ config, pkgs, ... }:
{
  xdg.configFile."qt5ct/colors/Penumbra.conf".text = ''
      #               FG              BTN_BG bright less brdark        less da     txt fg               br text              btn fg           txt bg     bg     shadow   sel bg     sel fg     link       visited           alt bg default          tooltip bg  tooltip_fg
    [ColorScheme]
      active_colors=#FFF7ED,          #303338, #303338, #303338, #24272B, #24272B, #FFF7ED,           #FFF7ED,           #FFF7ED,           #636363, #303338, #24272B, #00A0BE, #FFF7ED, #00A0BE, #FFF7ED,            #303338, #FFF7ED,           24272B,  #F2E6D4
    disabled_colors=#cbc6bf, #303338, #303338, #303338, #24272B, #24272B, #d8d2ca,  #d8d2ca,  #cbc6bf,  #636363, #303338, #24272B, #00A0BE, #FFF7ED, #00A0BE, #cbc6bf,   #303338, #cbc6bf,  #24272B, #beb6a9
    inactive_colors=#FFF7ED,          #303338, #303338, #303338, #24272B, #24272B, #FFF7ED,           #FFF7ED,           #FFF7ED,           #636363, #303338, #24272B, #00A0BE, #FFF7ED, #00A0BE, #FFF7ED,            #303338, #FFF7ED,           #24272B, #F2E6D4

    #               FG              BTN_BG     bright   less br  dark     less da  txt fg               br text  btn fg     txt bg     bg     shadow   sel bg     sel fg     link       visite alt bg default  tooltip bg  tooltip_fg
    #  active_colors=#FFF7ED,          #3E4044, #303338, #cbc7c4, #9f9d9a, #b8b5b2, #FFF7ED,           #ff0000, #F2E6D4, #636363, #303338, #767472, #00A0BE, #FFF7ED, #00A0BE, #FFF7ED,            #303338, #FFF7ED,           24272B, #F2E6D4
    #disabled_colors=#cbc6bf, #3E4044, #303338, #cbc7c4, #9f9d9a, #b8b5b2, #d8d2ca,  #ffec17, #F2E6D4, #636363, #303338, #767472, #00A0BE, #FFF7ED, #00A0BE, #cbc6bf,   #303338, #cbc6bf,  #24272B, #beb6a9
    #inactive_colors=#FFF7ED,          #3E4044, #303338, #cbc7c4, #9f9d9a, #b8b5b2, #FFF7ED,           #ff9040, #F2E6D4, #636363, #303338, #767472, #00A0BE, #FFF7ED, #00A0BE, #FFF7ED,            #303338, #FFF7ED,           #24272B, #F2E6D4

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
    active_colors=#FFF7ED,          #303338, #303338, #303338, #24272B, #24272B, #FFF7ED,           #FFF7ED,           #FFF7ED,           #636363, #303338, #24272B, #00A0BE, #FFF7ED, #00A0BE, #FFF7ED,            #303338, #FFF7ED,           24272B,  #F2E6D4, #cbc6bf
    disabled_colors=#cbc6bf, #303338, #303338, #303338, #24272B, #24272B, #d8d2ca,  #d8d2ca,  #cbc6bf,  #636363, #303338, #24272B, #00A0BE, #FFF7ED, #00A0BE, #cbc6bf,   #303338, #cbc6bf,  #24272B, #beb6a9,  #cbc6bf
    inactive_colors=#FFF7ED,          #303338, #303338, #303338, #24272B, #24272B, #FFF7ED,           #FFF7ED,           #FFF7ED,           #636363, #303338, #24272B, #00A0BE, #FFF7ED, #00A0BE, #FFF7ED,            #303338, #FFF7ED,           #24272B, #F2E6D4, #cbc6bf
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




