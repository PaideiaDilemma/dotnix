final: prev: {
  way-displays = prev.way-displays.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "PaideiaDilemma";
      repo = "way-displays";
      rev = "master";
      hash = "sha256-3mlmlbm9ax0EX+bPCNF3nJNYLqOzasACkbFBrfyI4Lk=";
    };
  });
}
