{
  config,
  lib,
  pkgs,
  ...
}: let
  removeHash = str: (lib.removePrefix "#" str);
  colors = config.colors;
  cfg = config.hyprhome;
in {
  programs.fzf = {
    enable = true;
    #enableFishIntegration = true;
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting

      function jj_context
        jj log --ignore-working-copy --no-graph --color always -r @ -T '
            surround(
                " (",
                ")",
                separate(
                    " ",
                    bookmarks.join(", "),
                    coalesce(
                        surround(
                            "\"",
                            "\"",
                            if(
                                description.first_line().substr(0, 24).starts_with(description.first_line()),
                                description.first_line().substr(0, 24),
                                description.first_line().substr(0, 23) ++ "…"
                            )
                        ),
                        "(no description set)"
                    ),
                    change_id.shortest(),
                    commit_id.shortest(),
                    if(conflict, "(conflict)"),
                    if(empty, "(empty)"),
                    if(divergent, "(divergent)"),
                    if(hidden, "(hidden)"),
                )
            )
        ' 2>/dev/null
      end

      function fish_prompt
        set -l nix_shell_info (
          if test -n "$IN_NIX_SHELL"
            echo -n " NIXSHELL "
          end
        )

        set -l last_status $status
        # Prompt status only if it's not 0
        set -l stat
        if test $last_status -ne 0
            set stat (set_color red)"[$last_status]"(set_color normal)
        end

        set -l jj_prompt (jj_context)
        if test -n "$jj_prompt"
          set jj_prompt "jj:$jj_prompt "
        end

        set -l git_prompt (fish_git_prompt)
        if test -n "$git_prompt"
          set git_prompt "git:$git_prompt "
        end

        set -l pwd_prompt (string join "" -- (set_color green) $PWD (set_color normal))
        if test -n "$DIRENV_FILE"
          set pwd_prompt (string join "" -- "DIRENV " $pwd_prompt)
        end

        string join ''' -- $jj_prompt $git_prompt $pwd_prompt \n $nix_shell_info $stat (set_color grey)'>'(set_color normal)
      end
    '';

    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "067e867debee59aee231e789fc4631f80fa5788e";
          hash = "sha256-emmjTsqt8bdI5qpx1bAzhVACkg0MNB/uffaRjjeuFxU=";
        };
      }
      {
        name = "loadenv";
        src = pkgs.fetchFromGitHub {
          owner = "berk-karaal";
          repo = "loadenv.fish";
          rev = "e5ad1b3e8cf779bd897a5fa4c0dc55a920b01ed7";
          hash = "sha256-RyGjJ8NxTqEr9MW7hnrTlry6fW+IF4el1IPUh7WIwxU=";
        };
      }
      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
          hash = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
        };
      }
    ];

    shellAliases = {
      "my-ip" = "curl ipinfo.io/ip 2>/dev/null && echo";
    };

    shellInit = ''
      export NVIM_APPNAME=lazyvim
    '';
  };

  programs.direnv = {
    enable = true;
  };
}
