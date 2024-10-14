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
              hash = "sha256-r9tNSrmGqqLRaHvzyXrXf9vtVk5xYhhDBiYjH1+edHE=";
            };
          });
      })
    ];
}
