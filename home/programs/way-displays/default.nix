{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hyprhome;
in {
  options.hyprhome.way-displays = {
    enable = mkOption {
      default = true;
      description = "Whether to enable the wallrnd.";
      type = types.bool;
    };
  };
  config = mkIf (cfg.way-displays.enable) {
    xdg.configFile."hypr/way-displays.cfg.yaml".text = ''
      ARRANGE: COLUMN
      ALIGN: MIDDLE
      SCALING: TRUE
      AUTO_SCALE: FALSE
      ORDER:
        - Samsung Electric Company S22D300 0x30333635
        - LG Electronics LG ULTRAGEAR 110MASXPXJ78
        - Samsung Electric Company U28D590
        - 'Philips Consumer Electronics Company PHL 275V8 UK\d+'
        - '!.*$'
        - 'HDMI-A-1'
        - 'eDP-1'
      SCALE:
        - NAME_DESC: Najing CEC Panda FPD Technology CO. ltd 0x0050
          SCALE: 1.25
          MODE: 10
        - NAME_DESC: InfoVision Optoelectronics (Kunshan) Co.,Ltd China 0x34D1
          SCALE: 1.25
        - NAME_DESC: 'Iiyama North America PL2783Q 1142965003433'
          SCALE: 1.25
        - NAME_DESC: 'Samsung Electric Company U28E850 HTPK600065'
          SCALE: 1.0
      MODE:
        - NAME_DESC: 'Philips Consumer Electronics Company PHL 275V8 UK\d+'
          MAX: TRUE
        - NAME_DESC: 'Samsung Electric Company U28E850 HTPK600065'
          WIDTH: 1920
          HEIGHT: 1080

      VRR_OFF:
        - 'eDP-1'
      CHANGE_SUCCESS_CMD: 'pgrep python3 | grep hyprsetwallpaper || hyprsetwallpaper -g -c'
      #CHANGE_SUCCESS_CMD: notify-send 'Monitors changed'
      #CHANGE_SUCCESS_CMD: 'echo "Monitors changed"'
    '';

    home.packages = with pkgs; [
      way-displays
    ];

    systemd.user.services.way-displays = {
      Unit = {
        Description = "Way Displays daemon";
        PartOf = ["graphical-session.target"];
        Requires = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${pkgs.way-displays}/bin/way-displays -c '${config.xdg.configHome}/hypr/way-displays.cfg.yaml' > '/tmp/way-displays.hmmm.log'";
        Restart = "always";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
