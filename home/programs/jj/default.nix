{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.difftastic
  ];
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = config.hyprhome.fullName;
        email = config.hyprhome.email;
      };
      colors = {
        "diff token" = {underline = false;};
      };
      aliases = {
        l = ["log" "--no-pager" "-r" "(main..@):: | (main..@)-"];
        s = ["status" "--no-pager"];
      };
      ui = {
        diff-formatter = ["difft" "--color=always" "$left" "$right"];
      };
      merge-tools.diffconflicts.program = "vimdiff";
    };
  };
}
