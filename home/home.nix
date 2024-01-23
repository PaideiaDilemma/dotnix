{ pkgs, userName, hardware, ... }: {

  imports = [
    ./programs
    ./scripts
    ./theme
  ];

  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    enableDebugInfo = false;
  };

  hyprhome = if hardware == "vm1" then {
    enable = true;
    enableAnimations = false;
    isVirtualMachine = true;
    monitors = {
      "Virtual-1" = {
        resolution = "1920x1080";
        position = "auto";
        scale = "1";
        initalWorkspace = "1";
      };
    };
  }

  else if hardware == "desktop" then {
    enable = true;
    monitors = {
      "DP-3" = {
        resolution = "1920x1080@144";
        position = "1920x597";
        scale = "1";
        initalWorkspace = "1";
      };
      "HDMI-A-1" = {
        resolution = "1920x1080@60";
        position = "0x1024";
        scale = "10";
        initalWorkspace = "10";
      };
      "DP-2" = {
        resolution = "1280x1024@75.025";
        position = "640x0";
        scale = "100";
        initalWorkspace = "100";
      };
    };
  } else {
    enable = true;
  };

  home.packages = (with pkgs; [

    # Graphical Applications
    webcord
    bottles
    krita
    inkscape
    wdisplays
    libreoffice
    thunderbird
    ghidra
    cutter
    cutterPlugins.rz-ghidra
    burpsuite

    # Terminal Applications
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
    scrcpy

  ]) ++ (with pkgs.gnome; [
    gnome-tweaks
    eog
  ]);

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
