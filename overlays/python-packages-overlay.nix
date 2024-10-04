final: prev: {
  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (pyfinal: pyprev: {
        pwntools =
          pyprev.pwntools.overridePythonAttrs
          (oldAttrs: {
            version = "4.15.0";
            src = prev.fetchFromGitHub {
              owner = "Gallopsled";
              repo = "pwntools";
              rev = "dev";
              hash = "sha256-AEw6I3B/5bxNGf3VoiOttHBJuNWaqc5xwLW0OmVO7I8=";
            };
          });
      })
    ];
}
