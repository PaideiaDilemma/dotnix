final: prev: {
  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (pyfinal: pyprev: {
        pwntools =
          pyprev.pwntools.overridePythonAttrs
          (oldAttrs: {
            version = "4.15.0beta1";
            src = prev.fetchFromGitHub {
              owner = "Gallopsled";
              repo = "pwntools";
              rev = "8b6543466a2265b9682fd04e85a98999123c7a94";
              hash = "sha256-/1ZO6j4Xex1DZ+gbTnu8bghgsutAAdhjVk8vbRM0gKE=";
            };

            debugger = final.pwndbg; # No worky?

            postFixup = final.lib.optionalString (!final.stdenv.hostPlatform.isDarwin) ''
              mkdir -p "$out/bin"
              makeWrapper "${final.pwndbg}/bin/pwndbg" "$out/bin/pwntools-gdb"
            '';
          });
      })
    ];
}
