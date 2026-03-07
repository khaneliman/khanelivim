{ config, ... }:
{
  plugins.fidget = {
    enable = config.khanelivim.ui.notifications == "snacks";
    settings = {
      progress = {
        poll_rate = 0;
        suppress_on_insert = false;
        ignore_done_already = false;
        ignore_empty_message = false;
        clear_on_detach.__raw = ''
          function(client_id)
            local client = vim.lsp.get_client_by_id(client_id)
            return client and client.name or nil
          end
        '';
        notification_group.__raw = ''
          function(msg)
            return msg.lsp_client.name
          end
        '';
        ignore = [ ];

        display = {
          render_limit = 10;
          done_ttl = 4;
          done_icon = "";
          done_style = "Constant";
          progress_ttl.__raw = "math.huge";
          progress_icon = {
            __unkeyed-1 = "dots";
          };
          progress_style = "WarningMsg";
          group_style = "Title";
          icon_style = "Special";
          priority = 30;
          skip_history = false;
          format_message.__raw = "require('fidget.progress.display').default_format_message";
          format_annote.__raw = ''
            function(msg)
              return msg.title
            end
          '';
          format_group_name.__raw = ''
            function(group)
              return tostring(group)
            end
          '';
          overrides = {
            rust_analyzer = {
              name = "rust-analyzer";
            };
          };
        };

        lsp = {
          progress_ringbuf_size = 0;
          log_handler = false;
        };
      };

      notification = {
        poll_rate = 10;
        filter = "info";
        history_size = 128;
        override_vim_notify = false;
        configs = {
          default.__raw = "require('fidget.notification').default_config";
        };
        window = {
          normal_hl = "NormalFloat";
          winblend = 0;
          border = "rounded";
          zindex = 45;
          max_width = 0;
          max_height = 0;
          x_padding = 1;
          y_padding = 1;
          align = "bottom";
          relative = "editor";
        };
        view = {
          stack_upwards = false;
          icon_separator = " ";
          group_separator = "─";
          group_separator_hl = "Comment";
          render_message.__raw = ''
            function(msg, cnt)
              return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
            end
          '';
        };
      };

      logger = {
        level = "warn";
        max_size = 10000;
        float_precision = 0.01;
        path.__raw = "string.format('%s/fidget.nvim.log', vim.fn.stdpath('cache'))";
      };
    };
  };
}
