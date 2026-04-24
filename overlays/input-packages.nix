{ flake }:
_final: prev:
let
  nixpkgs-master-packages = import flake.inputs.nixpkgs-master {
    inherit (prev.stdenv) system;
    config = {
      allowUnfree = true;
      allowAliases = false;
    };
  };
  # my-packages = flake.packages.${prev.stdenv.system};
  inherit (nixpkgs-master-packages) luaPackages vimPlugins;
in
{
  inherit (nixpkgs-master-packages)
    claude-code
    codex
    gemini
    github-copilot-cli
    opencode

    # TODO: Remove after hitting channel
    ;

  luaPackages = luaPackages // {
    #
    # Specific package overlays need to go in here to not get ignored
    #
  };

  vimPlugins = vimPlugins.extend (
    _self: super: {
      #
      # Specific package overlays need to go in here to not get ignored
      #
      nvim-java-core = super.nvim-java-core.overrideAttrs (old: {
        # TODO: File upstream and remove once nvim-java-core uses client:request.
        postPatch = ''
          ${old.postPatch or ""}

          substituteInPlace lua/java-core/ls/clients/jdtls-client.lua \
            --replace-fail "self.client.request(method, params, on_response, buffer)" "self.client:request(method, params, on_response, buffer)"
        '';
      });

      nvim-java-refactor = super.nvim-java-refactor.overrideAttrs (old: {
        # TODO: File upstream and remove once nvim-java-refactor exposes setup.
        postPatch = ''
          ${old.postPatch or ""}

          substituteInPlace lua/java-refactor/init.lua \
            --replace-fail "local event = require('java-core.utils.event')" "local event = require('java-core.utils.event')

          local function register_api(module, path, command, opts)
            local name = 'Java'

            for _, word in ipairs(path) do
              for _, sub_word in ipairs(vim.split(word, '_')) do
                name = name .. sub_word:sub(1, 1):upper() .. sub_word:sub(2)
              end
            end

            vim.api.nvim_create_user_command(name, command, opts or {})

            local func_name = table.remove(path)
            local node = module

            for _, key in ipairs(path) do
              node[key] = node[key] or {}
              node = node[key]
            end

            node[func_name] = command
          end" \
            --replace-fail "require('java').register_api({ 'refactor', api_name }, api, { range = 2 })" "local java = require('java')
              register_api(java, { 'refactor', api_name }, api, { range = 2 })" \
            --replace-fail "require('java').register_api({ 'build', api_name }, api, {})" "local java = require('java')
              register_api(java, { 'build', api_name }, api, {})"

          printf '\nM.setup = M.setup or function() end\nreturn M\n' >> lua/java-refactor/init.lua
        '';
      });
    }
  );
}
