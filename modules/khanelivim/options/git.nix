{ lib, ... }:
{
  options.khanelivim.git = {
    # keep-sorted start block=yes newline_separated=yes
    diffViewer = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "diffview"
          "unified"
          "mini-diff"
        ]
      );
      default = "unified";
      description = "Diff viewer plugin to use";
    };

    integrations = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "gitsigns"
          "snacks-gh"
          "snacks-gitbrowse"
          "snacks-lazygit"
          "git-worktree"
          "git-conflict"
        ]
      );
      default = [
        "gitsigns"
        "snacks-gh"
        "snacks-gitbrowse"
        "snacks-lazygit"
        "git-worktree"
        "git-conflict"
      ];
      description = "Git integration plugins to enable (complementary)";
    };
    #keep-sorted end
  };
}
