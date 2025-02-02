{
  pkgs,
  ...
}:
let
  whitespace-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "whitespace.nvim";
    version = "2024-08-11";
    src = pkgs.fetchFromGitHub {
      owner = "johnfrankmorgan";
      repo = "whitespace.nvim";
      rev = "406cd69216dd7847b0cb38486603a8ed5c4f8c77";
      sha256 = "sha256-LSK8Im42z8mvS/WbDQfE+ytl0wUYYpRDvAbO83OqGa8=";
    };
    meta.homepage = "https://github.com/johnfrankmorgan/whitespace.nvim/";
  };
in
{
  extraPlugins = [
    # pkgs.vimPlugins.whitespace-nvim
    whitespace-nvim
  ];

  # TODO: upstream module
  extraConfigLua = ''
    require('whitespace-nvim').setup({
        -- `highlight` configures which highlight is used to display
        -- trailing whitespace
        highlight = 'DiffDelete',

        -- `ignored_filetypes` configures which filetypes to ignore when
        -- displaying trailing whitespace
        ignored_filetypes = {
          'TelescopePrompt',
          'Trouble',
          'help',
          'dashboard',
          'snacks_dashboard',
          'ministarter'
        },

        ignore_terminal = true,

        return_cursor = true,
    })
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>lw";
      action.__raw = "require('whitespace-nvim').trim";
      options = {
        desc = "Whitespace trim";
      };
    }
  ];
}
