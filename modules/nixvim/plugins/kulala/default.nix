{
  config,
  lib,
  self,
  system,
  ...
}:
{
  extraPlugins = [
    self.packages.${system}.tree-sitter-kulala-http
  ];

  filetype = {
    extension = {
      http = "http";
      rest = "http";
    };
  };

  plugins = {
    kulala = {
      enable = config.khanelivim.editor.httpClient == "kulala";

      settings = {
        display_mode = "float";
        split_direction = "vertical";
        default_view = "headers_body";
        default_env = "dev";
        environment_scope = "b";
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
            pathresolver = [ ];
          };
          "application/yaml" = {
            ft = "yaml";
            formatter = [
              "yq"
              "."
            ];
          };
        };

        vscode_rest_client_environmentvars = true;

        # Debugging and output
        debug = false;
        disable_script_print_output = false;

        # SSL/TLS certificates
        certificates = { };

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
    };

    treesitter = {
      grammarPackages = [
        self.packages.${system}.tree-sitter-kulala-http
      ];
      luaConfig.post = # Lua
        ''
          do
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.kulala_http = {
              install_info = {
                url = "${self.packages.${system}.tree-sitter-kulala-http}",
                files = {"src/parser.c"},
              },
              filetype = "kulala_http",
            }
          end
        '';
    };

    which-key.settings.spec = lib.optionals config.plugins.kulala.enable [
      {
        __unkeyed-1 = "<leader>h";
        group = "HTTP Client";
        icon = "🌐";
      }
      {
        __unkeyed-1 = "<leader>he";
        group = "Environment";
      }
    ];
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
