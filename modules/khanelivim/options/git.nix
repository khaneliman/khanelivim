{ lib, ... }:
{
  options.khanelivim.git = {
    # keep-sorted start block=yes newline_separated=yes
    diffViewer = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "codediff"
          "diffview"
          "mini-diff"
          "unified"
        ]
      );
      default = "codediff";
      description = "Diff viewer plugin to use";
    };

    integrations = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "codediff"
          "git-conflict"
          "git-worktree"
          "gitsigns"
          "snacks-gh"
          "snacks-gitbrowse"
          "snacks-lazygit"
          "unified"
        ]
      );
      default = [
        "gitsigns"
        "snacks-gh"
        "snacks-gitbrowse"
        "snacks-lazygit"
        "git-worktree"
        "git-conflict"
        "unified"
      ];
      description = "Git integration plugins to enable (complementary)";
    };
    #keep-sorted end
  };
}
