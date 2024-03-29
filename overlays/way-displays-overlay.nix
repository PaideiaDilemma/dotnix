final: prev: {
  way-displays = prev.way-displays.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "PaideiaDilemma";
      repo = "way-displays";
      rev = "master";
      hash = "sha256-itT+YHPb6aGmZyjPLRVBTp0YSF3HuTeC1pv21G9hJOc=";
    };
  });
}
