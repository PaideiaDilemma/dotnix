final: prev: {
  way-displays = prev.way-displays.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "PaideiaDilemma";
      repo = "way-displays";
      rev = "master";
      hash = "sha256-3Cu+G+D8s0bDQgd11PmqAVj2qbS/qSigErrceRs0Kwg=";
    };
  });
}
