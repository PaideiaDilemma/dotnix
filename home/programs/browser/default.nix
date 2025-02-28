{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.hyprhome;
  colors = config.colors;
in {
  config = mkIf (cfg.gui.enable) {
    programs.chromium = {
      enable = true;
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
        {id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";} # privacy badger
        {id = "njdfdhgcmkocbgbhcioffdbicglldapd";} # local cdn
      ];
    };

    programs.firefox = {
      enable = true;
      profiles = {
        "netflix" = {
          isDefault = false;
          id = 1;
        };
        "asdfnerd" = {
          isDefault = true;
          settings = {
            # Those should be fine
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "geo.enabled" = false;
            "dom.battery.enabled" = false;
            "beacon.enabled" = false;
            "extensions.pocket.enabled" = false;
            # These are a bit more intrusive and might break some websites
            "privacy.resistFingerprinting" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.fingerprinting.enabled" = true;
            "browser.send_pings" = false;
            "network.dns.echconfig.enabled" = true;
            "network.dns.use_https_rr_as_altsvc" = true;
            # There regularily break websites like google
            "browser.safebrowsing.phishing.enabled" = false;
            "browser.safebrowsing.malware.enabled" = false;
          };
          search = {
            default = "DuckDuckGo";
            privateDefault = "DuckDuckGo";
            force = true;
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = ["@np"];
              };

              "NixOS Wiki" = {
                urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = ["@nw"];
              };
            };
          };
          userChrome = ''
            @layer Tabs {
              .tab-background {
                  /*border-radius: 6px 6px 0 0 !important;*/
                  border-radius: 6px !important;
                  margin: 2px 0px 2px !important;
                  padding: 0px !important;
                  /*margin-bottom: 0px !important;*/
                  /*box-shadow: 0 0 0px 0px ${colors.base.sky} !important;*/
                  border: 1px solid ${colors.base.sky} !important;
                  /*border-bottom-width: 0px !important;*/
                  max-height: 26px !important;
              }

              .tab-background:is([selected],[multiselected]) {
                  border: 1px solid ${colors.base.sun} !important;
              }

              .tab-content {
                  margin: 4px 1px 1px !important;
                  max-height: 26px !important;
                  vertical-align: middle !important;
              }

              .tabbrowser-tab {padding-inline: 1px !important;}
              /*.tabbrowser-tab:last-of-type {padding-inline: 1px 2px !important;}*/
              .tabbrowser-tab:first-of-type {padding-inline: 4px 1px !important;}

              #TabsToolbar {
                  border-bottom: 0px solid ${colors.base.sun} !important;
              }

              :root {
                  --tab-min-height: 30px !important;
              }
            }

            :root{
              /* reduce padding between menu items */
              --arrowpanel-menuitem-padding: var(--custom-menuitem-padding-vertical, 6px) var(--custom-menuitem-padding-horizontal, 8px) !important;
              --arrowpanel-menuitem-margin: 0 var(--custom-menuitem-margin, 4px) !important;
              --panel-subview-body-padding: var(--custom-menuitem-margin, 4px) 0 !important;
            }

            #urlbar-background {
              border-radius: 6px !important;
            }

            #urlbar[breakout][breakout-extend] > #urlbar-background {
              border-radius: 6px !important;
            }
          '';
        };
      };
    };
  };
}
