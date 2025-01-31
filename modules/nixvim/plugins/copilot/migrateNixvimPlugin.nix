{
  plugins.copilot-chat.settings = {
    prompts = {
      MigrateNixvimPlugin = {
        prompt = ''
          > /COPILOT_MIGRATE_NIXVIM_PLUGIN

          Analyze the selected nixvim plugin code and help migrate it to the new format using mkNeovimPlugin.

          Key changes to make:
          1. Convert to using lib.nixvim.plugins.mkNeovimPlugin
          2. Move options that dont go into a plugins `setup` call to `extraOptions`
             1. These options should stay camelCase.
             2. DO NOT migrate the plugin's own `package` option for the plugin there, it will stay top-level and simplified.
             3. DO NOT migrate the `enable` option for the plugin there, it will be removed.
             4. DO MIGRATE the package options for dependencies that we install in addition to the plugin.
                1. You don't need to change these really, just move them into `extraOptions`.
          3. Move options that go into `setup` calls into `settingsOptions`
             1. These options should be converted from camelCase to snake_case.
             2. If needing to use a submodule, prefer making it a freeformType whenever possible to allow flexibility.
                     `freeformType = types.attrsOf types.anything;`

          4. Update option definitions to use lib.nixvim.defaultNullOpts
             1. When any option types are repeated 3 or more times, use an inherit at the top let block.
          5. Add settingsExample
             1. We only need an example for around 10 options if there are a lot.
          6. Simplify the overall structure
          7. Make sure it contains require fields inside mkNeovimPlugin: name, package, maintainers.
             1. `name` should be the same as the option name from before
                `options.plugins.lean` -> name = "lean";
             2. Migrate the existing package option to a simplified approach that just needs the vimPlugin name
                  ```nix
                    package = lib.mkPackageOption pkgs "lean-nvim" {
                      default = [
                        "vimPlugins"
                        "lean-nvim"
                      ];
                    };
                  ```

                  `package = "lean-nvim";`

             3. If there are no maintainers, always set it to `khaneliman`.
          8. Make sure we handle renaming the options that go into `settingsOptions` by using `optionsRenamedToSettings`.
            ```nix
              optionsRenamedToSettings = [
                "formatters"
                "formattersByFt"
                "logLevel"
                "notifyOnError"
              ];
            ```
          9. If the plugin is using `extraOptionsOptions` also enable deprecating them. ALWAYS set this above `optionsRenamedToSettings`.
            deprecateExtraOptions = true;
          10. Replace all instances of `helpers` with `lib.nixvim`.
          11. If an option is supposed to be lua code, you need to use the `__raw` attribute.
              action.__raw = '''require("cmp").mapping.select_next_item()''';
              some_option.__raw = "function() print('hello, world!') end";
          12. Comments right above the attributes about deprecations saying when the deprecation was done.
              ```nix
                # TODO: Deprecated in 2025-01-31
                deprecateExtraOptions = true;
                optionsRenamedToSettings = [ "someOption" ];
              ```

          Please provide:
          - Required changes to convert to new format
          - Suggestions for settingsOptions structure
          - Example settings block
          - Any special handling needed for complex options

          Nix reminders:
          - Replace all instances of `with lib;` with inline references to the lib.
              1. When any references are repeated 3 or more times, use an inherit at the top let block.
          - Lists in nix don't use commas!!!!
            ```nix
              [ "one" "two" "three" ]
            ```

          Here's a simple example of a plugin:
          ```nix
            {
              lib,
              ...
            }:
            let
              inherit (lib.nixvim) defaultNullOpts mkNullOrOption;
              inherit (lib) types;
            in
            lib.nixvim.plugins.mkNeovimPlugin {
              name = "helpview";
              packPathName = "helpview.nvim";
              package = "helpview-nvim";

              maintainers = [ lib.maintainers.khaneliman ];

              description = '''
                Decorations for vimdoc/help files in Neovim

                Supports a vast amount of rendering customization.
                Refer to the plugin's [documentation](https://github.com/OXY2DEV/helpview.nvim/wiki) for more details.
              ''';

              extraOptions = {
                leanPackage = lib.mkPackageOption pkgs "lean" {
                  nullable = true;
                  default = "lean4";
                };
              };

              settingsOptions = {
                hooks = {
                  pre_tab_enter = defaultNullOpts.mkLuaFn null '''
                    Run custom logic before entering a tab.
                  ''';
                  nomodifiable = mkNullOrOption (types.listOf types.str) '''
                    A list of patterns to protect Lean file paths from being modified.
                  ''';
                };
              };

              settingsExample = {
                settings = {
                  pre_tab_enter.__raw = '''
                    function()
                      print("about to enter tab!")
                    end
                  ''';
                };
              };

              extraConfig = cfg: {
                extraPackages = [ cfg.leanPackage ];
              };
            }
          ```
        '';
      };
    };
  };
}
