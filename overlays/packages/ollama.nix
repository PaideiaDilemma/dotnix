{
  lib,
  pkgs,
  buildGoModule,
  fetchFromGitHub,
}: let
  gitDummy = ''
    git init -q
    git add .
    git \
    -c "user.name=John Doe" \
    -c "user.email=foo@bar" \
    commit -q -m "dummy"
  '';
in
  buildGoModule rec {
    name = "ollama";
    version = "0.1.24";

    src = fetchFromGitHub {
      owner = "jmorganca";
      repo = "ollama";
      rev = "v${version}";
      hash = "sha256-GwZA1QUH8I8m2bGToIcMMaB5MBnioQP4+n1SauUJYP8=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = with pkgs; [
      git
      cmake
    ];

    vendorHash = "sha256-wXRbfnkbeXPTOalm7SFLvHQ9j46S/yLNbFy+OWNSamQ=";

    GIT_CONFIG_NOSYSTEM = "1";
    GIT_CONFIG = "/dev/null";

    # So the build script of ollama uses git checkout and stuff
    # instead of keeping the .git directory, here I try to just init a new
    # repo with the same structure.
    preBuild = ''
      ${gitDummy}
      pushd llm/llama.cpp
      ${gitDummy}
      popd

      echo "
      [submodule \"llama.cpp\"]
        path = llm/llama.cpp
        url = ./llm/llama.cpp
        shallow = true
      " > .gitmodules

      go generate ./...
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
      maintainers = with maintainers; [];
      platforms = platforms.unix;
    };
  }
