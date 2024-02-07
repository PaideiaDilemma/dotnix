{ lib
, pkgs
, buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "ollama";
  version = "0.1.23";

  src = fetchFromGitHub {
    owner = "jmorganca";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-p7m3o9g/0Uco8ugxx2vsaBbaGcfQk4EyRico1aIrUyM=";
  };

  buildInputs = [ pkgs.llama-cpp ];
  propagatedBuildInputs = [ pkgs.rocmPackages.clr pkgs.clblast ];

  vendorHash = "sha256-QtsQVqRkwK61BJPVhFWtox6b9E8BpAIseNB0yhh+/90=";

  postPatch = ''
    substituteInPlace llm/payload_linux.go \
      --replace "llama.cpp/build/linux/*/*/lib/*.so*" "${pkgs.llama-cpp}/bin/llama-cpp-server"
  '';

  preBuild = ''
    git init -q
    ROCM_PATH=${pkgs.rocmPackages.clr} CLBlast_DIR=${pkgs.clblast}/lib/cmake/CLBlast go generate ./...
  '';

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/jmorganca/ollama/version.Version=${version}"
    "-X=github.com/jmorganca/ollama/server.mode=release"
  ];

  meta = with lib; {
    description = "Get up and running with large language models locally";
    homepage = "https://github.com/jmorganca/ollama";
    license = licenses.mit;
    mainProgram = "ollama";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
