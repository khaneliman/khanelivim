{
  plugins = {
    illuminate = {
      enable = true;

      # TODO: migrate to mkNeovimPlugin
      # lazyLoad.settings.event = "DeferredUIEnter";

      filetypesDenylist = [
        "dirvish"
        "fugitive"
        "neo-tree"
        "TelescopePrompt"
      ];
      largeFileCutoff = 3000;
    };
  };
}
