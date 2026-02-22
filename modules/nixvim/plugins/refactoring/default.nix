{ config, lib, ... }:
{
  plugins = {
    refactoring = {
      # refactoring.nvim documentation
      # See: https://github.com/ThePrimeagen/refactoring.nvim
      enable = true;

      settings = {
        # Prompt for return types in languages that support it
        prompt_func_return_type = {
          go = true;
          cpp = true;
          c = true;
          java = true;
        };

        # Prompt for function parameter types
        prompt_func_param_type = {
          go = true;
          cpp = true;
          c = true;
          java = true;
        };

        # Custom printf statements for debugging (function entry/exit)
        printf_statements = {
          cpp = [
            "std::cout << \"[DEBUG] %s\" << std::endl;"
            "fmt::print(\"[DEBUG] {\\n}\", \"%s\");"
            "spdlog::debug(\"%s\");"
          ];
          c = [
            "printf(\"[DEBUG] %s\\n\", \"%s\");"
            "fprintf(stderr, \"[DEBUG] %s\\n\", \"%s\");"
          ];
          go = [
            "fmt.Printf(\"[DEBUG] %s\\n\", \"%s\")"
            "log.Printf(\"[DEBUG] %s\", \"%s\")"
            "slog.Debug(\"%s\")"
          ];
          rust = [
            "println!(\"[DEBUG] {}\", \"%s\");"
            "eprintln!(\"[DEBUG] {}\", \"%s\");"
            "log::debug!(\"%s\");"
            "tracing::debug!(\"%s\");"
          ];
          python = [
            "print(f\"[DEBUG] %s\")"
            "logging.debug(\"%s\")"
            "logger.debug(\"%s\")"
          ];
          javascript = [
            "console.log('[DEBUG] %s');"
            "console.debug('[DEBUG] %s');"
            "logger.debug('%s');"
          ];
          typescript = [
            "console.log('[DEBUG] %s');"
            "console.debug('[DEBUG] %s');"
            "logger.debug('%s');"
          ];
          java = [
            "System.out.println(\"[DEBUG] %s\");"
            "logger.debug(\"%s\");"
            "log.debug(\"%s\");"
          ];
          cs = [
            "Console.WriteLine($\"[DEBUG] %s\");"
            "Debug.WriteLine($\"[DEBUG] %s\");"
            "_logger.LogDebug(\"%s\");"
          ];
        };

        # Custom print var statements (variable name and value)
        print_var_statements = {
          cpp = [
            "std::cout << \"%s: \" << %s << std::endl;"
            "fmt::print(\"{}: {\\n}\", \"%s\", %s);"
            "spdlog::debug(\"%s: {}\", %s);"
          ];
          c = [
            "printf(\"%s: %%d\\n\", %s);"
            "printf(\"%s: %%s\\n\", %s);"
            "fprintf(stderr, \"%s: %%p\\n\", %s);"
          ];
          go = [
            "fmt.Printf(\"%s: %%+v\\n\", %s)"
            "fmt.Printf(\"%s: %%#v\\n\", %s)"
            "log.Printf(\"%s: %%v\", %s)"
          ];
          rust = [
            "println!(\"%s: {:?}\", %s);"
            "println!(\"%s: {:#?}\", %s);"
            "dbg!(%s);"
            "eprintln!(\"%s: {:?}\", %s);"
          ];
          python = [
            "print(f\"%s: {%s}\")"
            "print(f\"%s: {%s!r}\")"
            "logging.debug(f\"%s: {%s}\")"
            "pprint.pprint({\"%s\": %s})"
          ];
          javascript = [
            "console.log('%s:', %s);"
            "console.debug('%s:', %s);"
            "console.log('%s:', JSON.stringify(%s, null, 2));"
          ];
          typescript = [
            "console.log('%s:', %s);"
            "console.debug('%s:', %s);"
            "console.log('%s:', JSON.stringify(%s, null, 2));"
          ];
          java = [
            "System.out.println(\"%s: \" + %s);"
            "logger.debug(\"%s: {}\", %s);"
            "System.out.printf(\"%s: %%s%%n\", %s);"
          ];
          cs = [
            "Console.WriteLine($\"%s: {%s}\");"
            "Debug.WriteLine($\"%s: {%s}\");"
            "_logger.LogDebug(\"%s: {Variable}\", %s);"
          ];
        };
      };

      lazyLoad = {
        settings = {
          cmd = "Refactor";
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.refactoring.enable [
    # Extract operations (visual mode)
    {
      mode = "x";
      key = "<leader>re";
      action = "<cmd>Refactor extract<cr>";
      options = {
        desc = "Extract Function";
      };
    }
    {
      mode = "x";
      key = "<leader>rE";
      action = "<cmd>Refactor extract_to_file<cr>";
      options = {
        desc = "Extract Function to File";
      };
    }
    {
      mode = "x";
      key = "<leader>rv";
      action = "<cmd>Refactor extract_var<cr>";
      options = {
        desc = "Extract Variable";
      };
    }

    # Inline operations (normal mode)
    {
      mode = "n";
      key = "<leader>ri";
      action = "<cmd>Refactor inline_var<CR>";
      options = {
        desc = "Inline Variable";
      };
    }
    {
      mode = "n";
      key = "<leader>rI";
      action = "<cmd>Refactor inline_func<CR>";
      options = {
        desc = "Inline Function";
      };
    }

    # Block operations (normal mode)
    {
      mode = "n";
      key = "<leader>rb";
      action = "<cmd>Refactor extract_block<CR>";
      options = {
        desc = "Extract Block";
      };
    }
    {
      mode = "n";
      key = "<leader>rB";
      action = "<cmd>Refactor extract_block_to_file<CR>";
      options = {
        desc = "Extract Block to File";
      };
    }

    # Debug operations (based on documentation)
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>rp";
      action.__raw = ''
        function()
          require('refactoring').debug.printf({below = false})
        end
      '';
      options = {
        desc = "Debug Printf";
      };
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>rP";
      action.__raw = ''
        function()
          require('refactoring').debug.print_var()
        end
      '';
      options = {
        desc = "Debug Print Variable";
      };
    }
    {
      mode = "n";
      key = "<leader>rc";
      action.__raw = ''
        function()
          require('refactoring').debug.cleanup({})
        end
      '';
      options = {
        desc = "Debug Cleanup";
      };
    }
  ];
}
