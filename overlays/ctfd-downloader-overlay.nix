final: prev: {
    ctfd-downloader = prev.stdenv.mkDerivation {
      name = "ctfd-downloader";
      src = prev.fetchFromGitHub {
        owner = "jonsth131";
        repo = "ctfd-downloader";
        rev = "56a899a2ae7ce3a2ae7958e6a3a74a150e61bcf7";
        hash = "sha256-bpF9xNKLO7+1pcauNafNOKVjQjizN3DO1x50vubwYFw=";
      };

    buildInputs = [
      (prev.python3.withPackages (ps:
        with ps; [
          requests
        ]))
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp $src/down.py $out/bin/ctfd-downloader
      chmod +x $out/bin/ctfd-downloader
    '';
  };
  
}
