{
  plugins.copilot-chat.settings = {
    prompts = {
      MigrateNixvimPlugin = {
        prompt = ''
          > /COPILOT_MIGRATE_NIXVIM_PLUGIN

          Analyze the selected nixvim plugin code and help migrate it to the new format using `mkNeovimPlugin`.

          Key changes to make:
          1. Convert to using `lib.nixvim.plugins.mkNeovimPlugin`.
          2. Move options that don't go into a plugin's `setup` call to `extraOptions`:
             1. These options should stay camelCase.
             2. DO NOT migrate the plugin's own `package` option there; it will stay top-level and simplified.
             3. DO NOT migrate the `enable` option there; it will be removed.
             4. DO MIGRATE the package options for dependencies that we install in addition to the plugin.
                1. You don't need to change these, just move them into `extraOptions`.
          3. Move options that go into `setup` calls into `settingsOptions`:
             1. These options should be converted from camelCase to snake_case.
             2. If needing to use a submodule, prefer making it a `freeformType` whenever possible to allow flexibility:
                `freeformType = types.attrsOf types.anything;`
             3. Do not remove text from the descriptions unnecessarily:
                1. If it is basic description stuff about the plugin default, then we can remove it.
                2. If it's explaining the purpose of the option, keep it.
                Example of something we can prune:
                ```nix
                  inSelect = helpers.defaultNullOpts.mkBool true '''
                    Default is `true`. # Not needed, the default is generated in docs.
                    Whether the name is selected when the float opens.
                    In some situations, just like wanting to change one or fewer characters, `inSelect` is not so useful.
                    You can tell the Lspsaga to start in normal mode using an extra argument like `:Lspsaga lsp_rename mode=n`.
                  ''';
                ```
             4. If it contains example text, we should convert the option to use the `exampleText` attribute:
                EXAMPLE before:
                ```nix
                  customHighlights = mkNullOrStrLuaFnOr (with types; attrsOf anything) '''
                    Override specific highlight groups to use other groups or a hex color.
                    You can provide either a lua function or directly an attrs.
                    Example:
                    ```lua
                      function(colors)
                        return {
                          Comment = { fg = colors.flamingo },
                          ["@constant.builtin"] = { fg = colors.peach, style = {} },
                          ["@comment"] = { fg = colors.surface2, style = { "italic" } },
                        }
                      end
                    ```
                    Default: `{}`
                  ''';
                ```
                EXAMPLE converted:
                ```nix
                  custom_highlights = mkNullOrStrLuaFnOr' {
                    type = (with types; attrsOf anything);
                    pluginDefault = {};
                    description = '''
                      Override specific highlight groups to use other groups or a hex color.
                      You can provide either a lua function or directly an attrs.
                    ''';
                    example = lib.literalExpression '''
                      ```lua
                        function(colors)
                          return {
                            Comment = { fg = colors.flamingo },
                            ["@constant.builtin"] = { fg = colors.peach, style = {} },
                            ["@comment"] = { fg = colors.surface2, style = { "italic" } },
                          }
                        end
                      ```
                    ''';
                  };
                ```
          4. Update option definitions to use `lib.nixvim.defaultNullOpts`:
             1. When any option types are repeated 3 or more times, use an `inherit` at the top `let` block.
          5. Add `settingsExample`:
             1. We only need an example for around 10 options if there are a lot.
          6. Simplify the overall structure.
          7. Make sure it contains required fields inside `mkNeovimPlugin`: `name`, `package`, `maintainers`:
             1. `name` should be the same as the option name from before:
                `options.plugins.lean` -> `name = "lean";`
             2. Migrate the existing package option to a simplified approach that just needs the vimPlugin name:
                EXAMPLE BEFORE:
                ```nix
                  package = lib.mkPackageOption pkgs "lean-nvim" {
                    default = [
                      "vimPlugins"
                      "lean-nvim"
                    ];
                  };
                ```
                EXAMPLE CONVERTED:
                `package = "lean-nvim";`
             3. If there are no maintainers, always set it to `khaneliman`.
          8. Make sure we handle renaming ALL the options that go into `settingsOptions` by using `optionsRenamedToSettings`.
             DO NOT IGNORE OPTIONS that were declared previously.
             These options should represent the names of the options before they were renamed.
             Nested attributes are nested lists:
             EXAMPLE before:
             ```nix
               ft = {
                 default = helpers.defaultNullOpts.mkStr "lean" '''
                   The default filetype for Lean files.
                 ''';
                 nomodifiable = helpers.mkNullOrOption (with types; listOf str) '''
                   A list of patterns which will be used to protect any matching Lean file paths from being accidentally modified (by marking the buffer as `nomodifiable`).
                   By default, this list includes the Lean standard libraries, as well as files within dependency directories (e.g. `_target`).
                   Set this to an empty table to disable.
                 ''';
               };
                horizontalPosition =
                  helpers.defaultNullOpts.mkEnum
                    [
                      "top"
                      "bottom"
                    ]
                    "bottom"
                    '''
                      Put the infoview on the top or bottom when horizontal.
                    ''';
             ```
             EXAMPLE converted:
             ```nix
               optionsRenamedToSettings = [
                 "horizontalPosition"
                 [
                   "ft"
                   "default"
                 ]
                 [
                   "ft"
                   "nonmodifiable"
                 ]
               ];
             ```
          9. If the plugin is using `extraOptionsOptions`, also enable deprecating them. ALWAYS set this above `optionsRenamedToSettings`:
             ```nix
               deprecateExtraOptions = true;
             ```
          10. Replace all instances of `helpers` with `lib.nixvim`.
          11. If an option is supposed to be lua code, you need to use the `__raw` attribute:
              EXAMPLE usage:
              ```nix
                action.__raw = '''require("cmp").mapping.select_next_item()''';
                some_option.__raw = "function() print('hello, world!') end";
              ```
          12. Comments right above the attributes about deprecations saying when the deprecation was done:
              EXAMPLE:
              ```nix
                # TODO: Deprecated in 2025-01-31
                deprecateExtraOptions = true;
                optionsRenamedToSettings = [ "someOption" ];
              ```

          Please provide:
          - Required changes to convert to new format
          - Suggestions for `settingsOptions` structure
          - Example settings block
          - Any special handling needed for complex options

          Nix reminders:
          - Replace all instances of `with lib;` with inline references to the lib:
            1. When any references are repeated 3 or more times, use an `inherit` at the top `let` block.
          - Lists in nix don't use commas:
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
