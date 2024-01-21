{ config, pkgs, lib, ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      "piracy" = {
        isDefault = true;
        containers = {
          "Work" = {
            id = 0;
            color = "yellow";
            icon = "briefcase";
          };
          "Personal" = {
            id = 1;
            color = "blue";
            icon = "fence";
          };
          "Content" = {
            id = 2;
            color = "green";
            icon = "vacation";
          };
        };
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "privacy.resistFingerprinting" = true;
        };
        search = {
          privateDefault = "DuckDuckGo";
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];

              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "NixOS Wiki" = {
              urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
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
                /*box-shadow: 0 0 0px 0px #8F8F8F !important;*/
                border: 1px solid #8F8F8F !important;
                /*border-bottom-width: 0px !important;*/
                max-height: 26px !important;
            }

            .tab-background:is([selected],[multiselected]) {
                border: 1px solid #FFF7ED !important;
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
                border-bottom: 0px solid #FFF7ED !important;
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
}
