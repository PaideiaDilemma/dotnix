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
        # `jj l` shows commits on the working-copy commit's (anonymous) bookmark
        # compared to the `main` bookmark
        l = ["log" "--no-pager" "-r" "(main..@):: | (main..@)-"];
      };
      ui = {
        diff-editor = "meld";
      };
      merge-tools.diffconflicts.program = "meld";
    };
  };
}
