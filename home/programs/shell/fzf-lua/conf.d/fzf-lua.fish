# quick and dirty adaptation from https://github.com/PatrickF1/fzf.fish
# to use fzf-lua's cli feature.
# TODO: improve, add fish history picker
# fzf.fish is only meant to be used in interactive mode. If not in interactive mode and not in CI, skip the config to speed up shell startup
if not status is-interactive && test "$CI" != true
    exit
end

function fzf_lua_wrap -a fzf_lua_picker --description "Takes the full nvim -l <path to fzf-lua cli.lua> and inserts it into the current commandline"
    set -f token (commandline --current-token)

    # expand any variables or leading tilde (~) in the token
    set -f expanded_token (eval echo -- $token)
    # unescape token because it's already quoted so backslashes will mess up the path
    set -f unescaped_exp_token (string unescape -- $expanded_token)

    set -f fzf_lua_command nvim -l $HOME/.local/share/$NVIM_APPNAME/site/pack/deps/opt/fzf-lua/scripts/cli.lua $fzf_lua_picker
    set -f result ($fzf_lua_command 2>/dev/null)

    if test $status -eq 0
        commandline --current-token --replace -- (string escape -- $result | string join ' ')
    end

    commandline --function repaint
end

# Install the default bindings, which are mnemonic and minimally conflict with fish's preset bindings
# Always installs bindings for insert and default mode for simplicity and b/c it has almost no side-effect
# https://gitter.im/fish-shell/fish-shell?at=60a55915ee77a74d685fa6b1
function fzf_lua_configure_bindings
  # no need to install bindings if not in interactive mode or running tests
  status is-interactive || test "$CI" = true; or return
    # If fzf bindings already exists, uninstall it first for a clean slate
    if functions --query _fzf_lua_uninstall_bindings
        _fzf_lua_uninstall_bindings
    end

    set -f key_sequences \e\cf \e\cl \e\cs \cr \e\cp \cv # \c = control, \e = escape
    for mode in default insert
        test -n $key_sequences[1] && bind --mode $mode $key_sequences[1] "fzf_lua_wrap files"
        test -n $key_sequences[2] && bind --mode $mode $key_sequences[2] "fzf_lua_wrap git_commits"
        test -n $key_sequences[3] && bind --mode $mode $key_sequences[3] "fzf_lua_wrap status"
        test -n $key_sequences[4] && bind --mode $mode $key_sequences[4] "fzf_lua_wrap command_history"
        test -n $key_sequences[5] && bind --mode $mode $key_sequences[5] "fzf_lua_wrap live_grep"
        test -n $key_sequences[6] && bind --mode $mode $key_sequences[6] "fzf_lua_wrap manpages"
    end

    function _fzf_lua_uninstall_bindings --inherit-variable key_sequences
        bind --erase -- $key_sequences
        bind --erase --mode insert -- $key_sequences
    end
end

fzf_lua_configure_bindings

# Doesn't erase autoloaded _fzf_lua* functions because they are not easily accessible once key bindings are erased
function _fzf_lua_uninstall --on-event fzf_uninstall
    _fzf_lua_uninstall_bindings

    set --erase _fzf_search_vars_command
    functions --erase _fzf_lua_uninstall _fzf_lua_uninstall_bindings fzf_lua_configure_bindings
    complete --erase fzf_lua_configure_bindings

    set_color cyan
    echo "fzf-lua.fish uninstalled."
    echo "You may need to manually remove fzf_lua_configure_bindings from your config.fish if you were using custom key bindings."
    set_color normal
end
