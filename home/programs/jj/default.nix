{...}: {
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
        l = ["log" "-r" "(main..@):: | (main..@)-"];
      };
      templates = {
        draft_commit_description = ''
          concat(
            description,
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.stat(72)),
            ),
            "\nJJ: ignore-rest\n",
            diff.git(),
          )
        '';
      };
    };
  };
}
