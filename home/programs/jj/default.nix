{pkgs, ...}: {
  home.packages = [
    pkgs.kdiff3
  ];
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Maximilian Seidler";
        email = "paideia_dilemma@losfuzzys.net";
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
