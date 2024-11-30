{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts = {
    packages = with pkgs; [
      nerd-fonts.hack
      nerd-fonts.fira
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
