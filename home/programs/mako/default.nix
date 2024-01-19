{ config, pkgs, ... }:
{
  services.mako = {
    enable = true;
    package = pkgs.mako;
    anchor = "bottom-left";
    backgroundColor = "#636363";
    textColor = "#FFF7ED";
    margin = "2";
    #outerMargin = 5;
    borderColor = "#FFF7ED";
    borderSize = 1;
    borderRadius = 6;
    progressColor = "over #CB7459CC";
    icons = true;
  };
}
