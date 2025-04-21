{
  pkgs,
  ...
}:
{
  extraPackages = [
    pkgs.claude-code
  ];

  # TODO: upstream module
  extraPlugins = [
    {
      # TODO: use upstreamed package
      plugin = pkgs.vimUtils.buildVimPlugin {
        pname = "claude-code.nvim";
        version = "2025-03-29";
        src = pkgs.fetchFromGitHub {
          owner = "greggh";
          repo = "claude-code.nvim";
          rev = "b5c64c42832e5c6c7a02e8e8aa44cfa38a4ae0b2";
          sha256 = "10s4bn1vcmvkgfxdcilqw85zzlfm2qipw25aqw7jjarys5y3jfik";
        };
        meta.homepage = "https://github.com/greggh/claude-code.nvim/";
        meta.hydraPlatforms = [ ];
      };
      optional = true;
    }
  ];

  plugins = {
    lz-n = {
      enable = true;
      plugins = [
        {
          __unkeyed-1 = "claude-code.nvim";
          cmd = [ "ClaudeCode" ];
          after = # Lua
            ''
              function()
                require ("claude-code").setup({
                  window = { position = "vertical"}
                })
              end
            '';
        }
      ];
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ac";
      action = "<cmd>ClaudeCode<CR>";
      options = {
        desc = "Claude Code";
      };
    }
  ];
}
