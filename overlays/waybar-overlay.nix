final: prev: rec {
   wireplumber_0_4 = prev.wireplumber.overrideAttrs (attrs: rec {
    version = "0.4.17";
    src = prev.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "wireplumber";
      rev = version;
      hash = "sha256-vhpQT67+849WV1SFthQdUeFnYe/okudTQJoL3y+wXwI=";
    };
  });
  waybar = prev.waybar.overrideAttrs {
    buildInputs = prev.waybar.buildInputs ++ [
      wireplumber_0_4
    ];
  };
}
