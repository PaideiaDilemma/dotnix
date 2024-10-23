{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["Hack" "FiraCode"];})
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Noto Serif"];
        sansSerif = ["Noto Sans"];
      };
    };
  };
}
