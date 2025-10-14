final: prev: {
  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (pyfinal: pyprev: {
        pwntools =
          pyprev.pwntools.overridePythonAttrs
          (oldAttrs: {
            version = "4.16.0dev";
            src = prev.fetchFromGitHub {
              owner = "Gallopsled";
              repo = "pwntools";
              rev = "480f174bcfb367297916acbc9b33878730257ae1";
              hash = "sha256-E3iNQe0NeZAb7F7b+0eU3DBne8YShN1RuqQoGpSaAbk=";
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
