{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPackages = lib.mkIf config.plugins.kulala.enable (
    with pkgs;
    [
      jq
      libxml2
      yq-go
      prettier
    ]
  );

  filetype = {
    extension = {
      http = "http";
      rest = "http";
    };
  };

  plugins = {
    kulala = {
      # kulala.nvim documentation
      # See: https://github.com/mistweaverco/kulala.nvim
      enable = config.khanelivim.editor.httpClient == "kulala";

      lazyLoad.settings = {
        ft = [ "http" ];
      };

      settings = {
        # Environment options
        default_env = "dev";
        environment_scope = "b";
        vscode_rest_client_environmentvars = true;

        # Request options
        request_timeout = 5000;
        urlencode = "always";
        format_json_on_redirect = true;

        # UI Options
        ui = {
          display_mode = "float";
          split_direction = "vertical";
          default_view = "headers_body";
          show_icons = "above_request";
          icons = {
            inlay = {
              loading = "⏳";
              done = "✅";
              error = "❌";
            };
            lualine = "🌐";
          };
          winbar = true;
          default_winbar_panes = [
            "body"
            "headers"
            "headers_body"
          ];
          disable_script_print_output = false;
          show_variable_info_text = false;
          show_request_summary = true;

          # Scratchpad default content for quick testing
          scratchpad_default_contents = [
            "@API_BASE=https://api.example.com"
            "@TOKEN=your_token_here"
            ""
            "# @name Example GET Request"
            "GET {{API_BASE}}/users HTTP/1.1"
            "Accept: application/json"
            "Authorization: Bearer {{TOKEN}}"
            ""
            "###"
            ""
            "# @name Example POST Request"
            "POST {{API_BASE}}/users HTTP/1.1"
            "Content-Type: application/json"
            "Authorization: Bearer {{TOKEN}}"
            ""
            "{"
            "  \"name\": \"John Doe\","
            "  \"email\": \"john@example.com\""
            "}"
          ];
        };

        contenttypes = {
          "application/json" = {
            ft = "json";
            formatter = [
              "jq"
              "."
            ];
            pathresolver.__raw = "require('kulala.parser.jsonpath').parse";
          };
          "application/xml" = {
            ft = "xml";
            formatter = [
              "xmllint"
              "--format"
              "-"
            ];
            pathresolver = [
              "xmllint"
              "--xpath"
              "{{path}}"
              "-"
            ];
          };
          "text/html" = {
            ft = "html";
            formatter = [
              "xmllint"
              "--format"
              "--html"
              "-"
            ];
          };
          "application/yaml" = {
            ft = "yaml";
            formatter = [
              "yq"
              "."
            ];
          };
          "application/graphql" = {
            ft = "graphql";
            formatter = [
              "prettier"
              "--stdin-filepath"
              "file.graphql"
            ];
          };
          "application/javascript" = {
            ft = "javascript";
            formatter = [
              "prettier"
              "--stdin-filepath"
              "file.js"
            ];
          };
        };

        # Debugging and output
        debug = false;

        # SSL/TLS certificates
        certificates = { };
      };
    };

  };

  keymaps = lib.mkIf config.plugins.kulala.enable [
    # Core HTTP request functionality
    {
      mode = "n";
      key = "<leader>hr";
      action = "<cmd>lua require('kulala').run()<cr>";
      options = {
        desc = "Run HTTP request under cursor";
      };
    }
    {
      mode = "n";
      key = "<leader>hR";
      action = "<cmd>lua require('kulala').replay()<cr>";
      options = {
        desc = "Replay last HTTP request";
      };
    }
    {
      mode = "n";
      key = "<leader>hc";
      action = "<cmd>lua require('kulala').copy()<cr>";
      options = {
        desc = "Copy request as cURL command";
      };
    }
    {
      mode = "n";
      key = "<leader>hi";
      action = "<cmd>lua require('kulala').inspect()<cr>";
      options = {
        desc = "Inspect current request";
      };
    }

    # Navigation between requests
    {
      mode = "n";
      key = "<leader>hp";
      action = "<cmd>lua require('kulala').jump_prev()<cr>";
      options = {
        desc = "Jump to previous request";
      };
    }
    {
      mode = "n";
      key = "<leader>hn";
      action = "<cmd>lua require('kulala').jump_next()<cr>";
      options = {
        desc = "Jump to next request";
      };
    }

    # View management
    {
      mode = "n";
      key = "<leader>ht";
      action = "<cmd>lua require('kulala').toggle_view()<cr>";
      options = {
        desc = "Toggle view (body/headers/both)";
      };
    }
    {
      mode = "n";
      key = "<leader>hq";
      action = "<cmd>lua require('kulala').close()<cr>";
      options = {
        desc = "Close response window";
      };
    }

    # Environment management
    {
      mode = "n";
      key = "<leader>hes";
      action = "<cmd>lua require('kulala').set_selected_env()<cr>";
      options = {
        desc = "Set selected environment";
      };
    }
    {
      mode = "n";
      key = "<leader>hei";
      action = "<cmd>lua require('kulala').show_stats()<cr>";
      options = {
        desc = "Show request statistics";
      };
    }

    # Scratchpad for quick testing
    {
      mode = "n";
      key = "<leader>hs";
      action = "<cmd>lua require('kulala').scratchpad()<cr>";
      options = {
        desc = "Open HTTP scratchpad";
      };
    }

    # Quick access for .http files
    {
      mode = "n";
      key = "<CR>";
      action = "<cmd>lua require('kulala').run()<cr>";
      options = {
        desc = "Run HTTP request under cursor";
        buffer = true;
      };
    }
  ];

  autoGroups = {
    kulala_group = { };
  };

  # Auto commands for .http files
  autoCmd = lib.mkIf config.plugins.kulala.enable [
    {
      event = [ "FileType" ];
      pattern = [ "http" ];
      group = "kulala_group";
      callback.__raw = ''
        function()
          vim.keymap.set("n", "<CR>", require('kulala').run, { buffer = true, desc = "Run HTTP request" })
          vim.keymap.set("n", "[r", require('kulala').jump_prev, { buffer = true, desc = "Previous request" })
          vim.keymap.set("n", "]r", require('kulala').jump_next, { buffer = true, desc = "Next request" })
        end
      '';
    }
  ];
}
