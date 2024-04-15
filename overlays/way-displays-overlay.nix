final: prev: {
  way-displays = prev.way-displays.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "PaideiaDilemma";
      repo = "way-displays";
      rev = "master";
      hash = "sha256-v0c1Mi8zhBO6gnY/fAKzoU/e+DjroEWNA0LgPSDNS9w=";
    };
  });
}
