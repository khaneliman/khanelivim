{
  config,
  lib,
  ...
}:
{
  plugins = {
    snacks = {
      settings = {
        gitbrowse.enabled = lib.elem "snacks-gitbrowse" config.khanelivim.git.integrations;
      };
    };
  };

  keymaps = lib.mkIf (lib.elem "snacks-gitbrowse" config.khanelivim.git.integrations) [
    {
      mode = "n";
      key = "<leader>go";
      action = "<cmd>lua Snacks.gitbrowse()<CR>";
      options = {
        desc = "Open file in browser";
      };
    }
    {
      mode = "v";
      key = "<leader>go";
      action = "<cmd>lua Snacks.gitbrowse()<CR>";
      options = {
        desc = "Open selection in browser";
      };
    }
    {
      mode = "n";
      key = "<leader>gO";
      action = "<cmd>lua Snacks.gitbrowse({what = 'repo'})<CR>";
      options = {
        desc = "Open repository in browser";
      };
    }
    {
      mode = "n";
      key = "<leader>gm";
      action = "<cmd>lua Snacks.gitbrowse({branch = 'main'})<CR>";
      options = {
        desc = "Open file on main branch";
      };
    }
    {
      mode = "n";
      key = "<leader>gM";
      action = "<cmd>lua Snacks.gitbrowse({branch = 'master'})<CR>";
      options = {
        desc = "Open file on master branch";
      };
    }
  ];
}
