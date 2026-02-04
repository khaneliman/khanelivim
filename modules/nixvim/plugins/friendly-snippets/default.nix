{ config, lib, ... }:
let
  friendlyEnabled = config.plugins.friendly-snippets.enable;
  frameworksRoot = "${config.plugins.friendly-snippets.package}/snippets/frameworks";
in
{
  # NOTE:
  # Split lines in a file
  # can use when evaluating list of failed builds
  # :s/\s\+/\r/g

  plugins = {
    friendly-snippets.enable = true;

    mini-snippets.settings.snippets = lib.mkIf friendlyEnabled {
      __unkeyed-2.__raw = "require('mini.snippets').gen_loader.from_file('${config.plugins.friendly-snippets.package}/snippets/global.json')";
      __unkeyed-3.__raw = ''
        function(context)
          local lang = context and context.lang
          if not lang then return end

          local map = {
            html = { "${frameworksRoot}/angular/html.json" },
            typescript = { "${frameworksRoot}/angular/typescript.json", "${frameworksRoot}/remix-ts.json" },
            typescriptreact = { "${frameworksRoot}/angular/typescript.json", "${frameworksRoot}/remix-ts.json" },
            cs = { "${frameworksRoot}/unity.json" },
            cpp = { "${frameworksRoot}/unreal.json" },
          }

          local files = map[lang]
          if not files then return end

          local out = {}
          for _, file in ipairs(files) do
            local ok, data = pcall(MiniSnippets.read_file, file)
            if ok and data then table.insert(out, data) end
          end

          if #out == 0 then return end
          return out
        end
      '';
    };
  };
}
