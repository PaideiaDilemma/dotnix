{pkgs, ...}: {
  home.packages = [
    pkgs.meld
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
        diff-editor = "meld";
      };
      merge-tools.diffconflicts.program = "meld";
    };
  };
}
