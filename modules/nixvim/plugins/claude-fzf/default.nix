{
  config,
  lib,
  pkgs,
  ...
}:
{
  # TODO: Consider upstreaming this module to nixvim
  options.plugins.claude-fzf = {
    enable = lib.mkEnableOption "claude-fzf" // {
      default = true;
    };

    package = lib.mkPackageOption pkgs.vimPlugins "claude-fzf" {
      default = "claude-fzf-nvim";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {
        keymaps = {
          files = "<leader>acF";
          grep = "<leader>acg";
          buffers = "<leader>acB";
          git_files = "<leader>acG";
          directory_files = "<leader>acD";
        };

        fzf_opts = {
          preview = {
            border = "rounded";
          };
          winopts = {
            width = 0.7;
          };
        };

        logging.level = "WARN";
      };
      description = "Configuration for claude-fzf";
    };
  };

  config = lib.mkIf config.plugins.claude-fzf.enable {
    extraPlugins = [
      config.plugins.claude-fzf.package
    ];

    extraConfigLua = ''
      require('claude-fzf').setup(${lib.generators.toLua { } config.plugins.claude-fzf.settings})
    '';

    keymaps = [ ];
  };
}
