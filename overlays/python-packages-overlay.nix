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
              rev = "32ba51e965643150a91e3f567579d99dae0ba38f";
              hash = "sha256-/1ZO6j4Xex1DZ+gbTnu8bghgsutAAdhjVk8vbRM0gKE=";
            };

            debugger = final.pwndbg;
          });
      })
    ];
}
