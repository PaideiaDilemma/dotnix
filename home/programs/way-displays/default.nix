{ config, lib, pkgs, ... }:
{
  xdg.configFile."hypr/way-displays.cfg.yaml".text = ''
ARRANGE: COLUMN
ALIGN: MIDDLE
SCALING: TRUE
AUTO_SCALE: FALSE
ORDER:
  - Samsung Electric Company S22D300 0x30333635
  - LG Electronics LG ULTRAGEAR 110MASXPXJ78
  - Samsung Electric Company U28D590
  - Philips Consumer Electronics Company PHL 275V8 UK02239005336
SCALE:
  - NAME_DESC: Najing CEC Panda FPD Technology CO. ltd 0x0050
    SCALE: 1.25
  - NAME_DESC: InfoVision Optoelectronics (Kunshan) Co.,Ltd China 0x34D1
    SCALE: 1.25
MODE:
  - NAME_DESC: Philips Consumer Electronics Company PHL 275V8 UK02239005336
    MAX: TRUE
  '';

  home.packages = with pkgs; [
    way-displays
  ];

  systemd.user.services.way-displays = {
    Unit = {
      Description = "Way Displays daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.way-displays}/bin/way-displays -c '${config.xdg.configHome}/hypr/way-displays.cfg.yaml' > '/tmp/way-displays.hmmm.log'";
      Restart = "always";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
