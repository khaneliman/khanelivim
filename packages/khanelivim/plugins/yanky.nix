{
  plugins = {
    yanky = {
      enable = true;
      settings = {
        ring = {
          history_length = 100;
          storage = "sqlite";
          storage_path.__raw = "vim.fn.stdpath('data') .. '/databases/yanky.db'";
          sync_with_numbered_registers = true;
          cancel_event = "update";
          ignore_registers = [ "_" ];
          update_register_on_cycle = false;
        };
      };
    };
  };
}
