{ config, ... }:
{
  plugins = {
    otter = {
      inherit (config.plugins.treesitter) enable;
      autoActivate = false;

      settings = {
        handle_leading_whitespace = true;
        lsp = {
          diagnostic_update_events = [
            "BufWritePost"
            "InsertLeave"
            "TextChanged"
          ];
        };
        buffers = {
          set_filetype = true;
          # write_to_disk = true;
        };
      };
    };
  };
}
