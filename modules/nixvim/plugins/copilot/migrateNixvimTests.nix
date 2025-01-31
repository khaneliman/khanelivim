{
  plugins.copilot-chat.settings = {
    prompts = {
      MigrateNixvimPluginTest = {
        prompt = ''
          > /COPILOT_MIGRATE_NIXVIM_PLUGIN_TEST

          Analyze the selected nixvim plugin tests and update the options to use the new names in their new locations.

          Key changes to make:
          1. `extraOptions`
             1. These options should stay camelCase.
             2. They stay at the top level of a plugin config.
          2. Move options that are part of `settingsOptions` to be nested under a new `settings` attribute.
             1. These options should be converted from camelCase to snake_case.

             ```nix
                 lspDisabled = {
                  plugins = {
                    lsp = {
                      enable = true;

                      servers.leanls.enable = true;
                    };

                    lean = {
                      enable = true;
                      leanPackage = pkgs.lean;

                      lsp.enable = false;
                    };
                  };
                };
             ```

             ```nix
                 lspDisabled = {
                  plugins = {
                    lsp = {
                      enable = true;

                      settings.servers.leanls.enable = true;
                    };

                    lean = {
                      enable = true;
                      leanPackage = pkgs.lean;

                      settings.lsp.enable = false;
                    };
                  };
                };
             ```
          3. If an option is supposed to be lua code, you need to use the `__raw` attribute.
              action.__raw = '''require("cmp").mapping.select_next_item()''';
              some_option.__raw = "function() print('hello, world!') end";
          4. We don't want much white space in the file. New lines should be avoided and collapse attribute sets that don't have many attributes.
             ```nix
                settings = {
                  servers = {
                    leanls = {
                      enable = true;
                    };
                  };
                };
             ```
             should be 
             ```nix
              settings.servers.leanls.enable = true;
             ```
             and
             ```nix
               ft = {
                default = "lean";
                nomodifiable = null;
              };
             ```
             should stay the same.


          Please provide:
          - Required changes to convert to new format

          Nix reminders:
          - Replace all instances of `with lib;` with inline references to the lib.
              1. When any references are repeated 3 or more times, use an inherit at the top let block.
          - Lists in nix don't use commas!!!!
            ```nix
              [ "one" "two" "three" ]
            ```
        '';
      };
    };
  };
}
