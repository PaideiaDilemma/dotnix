final: prev: {
  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (pyfinal: pyprev: {
        pwntools =
          pyprev.pwntools.overridePythonAttrs
          (oldAttrs: {
            version = "4.15.0dev";
            src = prev.fetchFromGitHub {
              owner = "Gallopsled";
              repo = "pwntools";
              rev = "61804b169bf88ce40a798095ebd7d808b0fe35cb";
              hash = "sha256-PK8SPhhAQ+0J6vPfINFmyOr4DQRdU3+oFZVxtp0Df9Y=";
            };
          });
      })
    ];
}
