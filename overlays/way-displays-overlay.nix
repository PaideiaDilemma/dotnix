final: prev: {
  way-displays = prev.way-displays.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "PaideiaDilemma";
      repo = "way-displays";
      rev = "master";
      hash = "sha256-s6yJ6eKX8FPmZuKw85IAqNTzlqx70Jz2Hqez3e07V7w=";
    };
  });
}
