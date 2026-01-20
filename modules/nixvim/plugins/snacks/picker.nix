{
  config,
  lib,
  ...
}:
{
  imports = [
    ./picker/git.nix
    ./picker/lsp.nix
    ./picker/neovim.nix
    ./picker/search.nix
    ./picker/ui.nix
  ];

  plugins = {
    snacks = {
      settings = lib.mkIf (config.khanelivim.picker.tool == "snacks") {
        picker = {
          sources = {
            noice = lib.mkIf config.plugins.noice.enable {
              confirm = [
                "yank"
                "close"
              ];
            };
          };
          win = {
            list = {
              on_buf.__raw = ''
                function(self)
                    self:execute 'calculate_file_truncate_width'
                end
              '';
            };
            preview = {
              on_buf.__raw = ''
                function(self)
                    self:execute 'calculate_file_truncate_width'
                end
              '';
              on_close.__raw = ''
                function(self)
                    self:execute 'calculate_file_truncate_width'
                end
              '';
            };
          };
          layouts = {
            select = {
              layout = {
                relative = "cursor";
                width = 70;
                min_width = 0;
                row = 1;
              };
            };
          };
        };
      };
    };

    which-key.settings.spec = lib.optionals config.plugins.snacks.enable [
      {
        __unkeyed-1 = "<leader>s";
        mode = [
          "n"
          "x"
        ];
        desc = "Search";
      }
    ];
  };
}
