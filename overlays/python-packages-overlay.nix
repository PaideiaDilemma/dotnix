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
              hash = "sha256-FC/o0Xg9rdXAPtljydGof0fFPq5YW1OJWa/4jBYBwfE=";
            };
          });
      })
    ];
}
