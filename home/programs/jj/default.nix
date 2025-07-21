{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.kdiff3
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
        diff-editor = "kdiff3";
      };
      merge-tools.diffconflicts.program = "vimdiff";
    };
  };
}
