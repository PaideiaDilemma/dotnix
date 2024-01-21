{ pkgs, lib, ... }:
let
  lazyvimConfigSrc = pkgs.fetchFromGitHub {
    owner = "PaideiaDilemma";
    repo = "LazyVim";
    rev = "main";
    hash = "sha256-i+gFJ+ssx3HnNpuXw/Ga+HQ8YsRmMvU67i7o1XkL7xo=";
  };

  treesitterPkgs = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
    p.bash
    p.comment
    p.css
    p.dockerfile
    p.fish
    p.gitattributes
    p.gitignore
    p.go
    p.gomod
    p.gowork
    p.hcl
    p.javascript
    p.jq
    p.json5
    p.json
    p.lua
    p.make
    p.markdown
    p.nix
    p.python
    p.rust
    p.toml
    p.typescript
    p.vue
    p.yaml
  ]));
in
{
  home.packages = with pkgs; [
    ripgrep
    fd
  ];

  programs.neovim =
    {
      enable = true;
      #package = pkgs.neovim-nightly;
      vimAlias = true;

      plugins = [
        treesitterPkgs
      ];
    };

  xdg.configFile."lazyvim" = {
    source = lazyvimConfigSrc;
    recursive = true;
  };

  home.file."./.local/share/nvim/nix/nvim-treesitter/" = {
    source = treesitterPkgs;
    recursive = true;
  };
}
