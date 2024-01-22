{ pkgs, ... }: {

  imports = [
    ./programs
    ./scripts
    ./theme
  ];

  home = {
    username = "max";
    homeDirectory = "/home/max";
  };

  home.packages = (with pkgs; [

    #User Apps
    webcord
    bottles
    krita
    inkscape
    wdisplays
    libreoffice
    thunderbird
    cutter

    #utils
    wlr-randr
    git
    rustup
    gnumake
    catimg
    curl
    appimage-run
    mako
    pavucontrol
    sqlite
    file
    wget
    grim
    slurp
    btop
    rofi-wayland
    wl-clipboard
    imv
    hyprpicker

    #misc
    cava
    tty-clock
    hyprpaper

  ]) ++ (with pkgs.gnome; [
    gnome-software
    gnome-tweaks
    eog
  ]);

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Tokyonight-Dark-B-LB";
    };
  };

  xdg.configFile."user-dirs.dirs".text = ''
    XDG_DESKTOP_DIR="$HOME/desk"
    XDG_DOCUMENTS_DIR="$HOME/doc"
    XDG_MUSIC_DIR="$HOME/media/music"
    XDG_PICTURES_DIR="$HOME/media/picture"
    XDG_PUBLICSHARE_DIR="$HOME/pub"
    XDG_TEMPLATES_DIR="$HOME/template"
    XDG_VIDEOS_DIR="$HOME/media/video"
    XDG_DOWNLOAD_DIR="$HOME/installf"
  '';

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Maximilian Seidler";
    userEmail = "maximilian.seidler@soundwork.at";
  };

  home.stateVersion = "23.11";
}
