{pkgs, ...}: {
  hyprhome = {
    gui.enable = false;
    hyprland = {
      enable = false;
    };
  };

  home.packages = with pkgs; [
    nodejs
    pinentry-qt
    libsecret
  ];
}
