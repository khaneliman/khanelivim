{
  plugins = {
    illuminate = {
      enable = true;

      # TODO: migrate to mkNeovimPlugin
      # lazyLoad.settings.event = "DeferredUIEnter";

      settings = {
        filetypes_denylist = [
          "dirvish"
          "fugitive"
          "neo-tree"
          "TelescopePrompt"
        ];
        large_file_cutoff = 3000;
      };
    };
  };
}
