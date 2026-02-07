{pkgs, ...}: {
  dotnix = {
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
