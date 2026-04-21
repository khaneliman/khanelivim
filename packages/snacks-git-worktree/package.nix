{
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "snacks-git-worktree.nvim";
  version = "0-unstable-04-21-2026";

  src = ./plugin;
}
