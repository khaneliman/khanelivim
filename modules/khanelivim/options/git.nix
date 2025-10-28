{ lib, ... }:
{
  options.khanelivim.git = {
    integrations = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "gitsigns"
          "snacks-gitbrowse"
          "snacks-lazygit"
          "git-worktree"
          "git-conflict"
        ]
      );
      default = [
        "gitsigns"
        "snacks-gitbrowse"
        "snacks-lazygit"
        "git-worktree"
        "git-conflict"
      ];
      description = "Git integration plugins to enable (complementary)";
    };
  };
}
