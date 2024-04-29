final: prev: {
  way-displays = prev.way-displays.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "PaideiaDilemma";
      repo = "way-displays";
      rev = "master";
      hash = "sha256-J2mLDisErTjxkf7RDk+uwe36gZAffXEyMHshc7+Flko=";
    };
  });
}
