{
  config,
  lib,
  pkgs,
  ...
}:
{
  extraPackages = lib.mkIf config.plugins.dap.enable (
    with pkgs;
    [
      netcoredbg
    ]
  );

  globals = {
    # Yoinked from https://github.com/fm39hz/nvim-lazyvim/blob/main/lua/plugins/development/language/csharp.lua
    find_godot_project.__raw = ''
      function(start_dir)
        if not _G.godot_project_cache then
          _G.godot_project_cache = {}
        end
        local current_dir = vim.fn.fnamemodify(start_dir or vim.fn.getcwd(), ":p")
        if current_dir ~= "/" then
          current_dir = current_dir:gsub("/$", "")
        end

        if _G.godot_project_cache[current_dir] then
          return _G.godot_project_cache[current_dir].file_path, _G.godot_project_cache[current_dir].dir_path
        end

        local function has_project_file(dir)
          local project_file = dir .. "/project.godot"
          local stat = vim.uv.fs_stat(project_file)
          if stat and stat.type == "file" then
            return project_file, dir
          else
            return nil, nil
          end
        end

        -- Check current directory
        local project_file, project_dir = has_project_file(current_dir)
        if project_file then
          _G.godot_project_cache[current_dir] = { file_path = project_file, dir_path = project_dir }
          return project_file, project_dir
        end

        -- Search parent directories (up to 5 levels)
        local max_depth = 5
        local dir = current_dir
        for _ = 1, max_depth do
          local parent = vim.fn.fnamemodify(dir, ":h")
          if parent == dir then break end
          dir = parent
          local p_file, p_dir = has_project_file(dir)
          if p_file then
            _G.godot_project_cache[current_dir] = { file_path = p_file, dir_path = p_dir }
            return p_file, p_dir
          end
        end

        -- Search immediate subdirectories
        local handle = vim.uv.fs_scandir(current_dir)
        if handle then
          while true do
            local name, type = vim.uv.fs_scandir_next(handle)
            if not name then break end
            if type == "directory" then
              local subdir = current_dir .. "/" .. name
              local p_file, p_dir = has_project_file(subdir)
              if p_file then
                _G.godot_project_cache[current_dir] = { file_path = p_file, dir_path = p_dir }
                return p_file, p_dir
              end
            end
          end
        end

        return nil, nil
      end
    '';
  };

  plugins = {
    dap = {
      adapters = {
        # Optional environment variable:
        #   GODOT - Path to Godot executable (defaults to "godot" in PATH)
        #
        # Example: export GODOT="/usr/local/bin/godot4"
        godot.__raw = ''
          function(on_config, config, parent_session)
            local search_dirs = {}
            local seen = {}
            local function add_search_dir(dir)
              if dir and dir ~= "" and vim.fn.isdirectory(dir) == 1 then
                local normalized = vim.fn.fnamemodify(dir, ":p")
                if normalized ~= "/" then
                  normalized = normalized:gsub("/$", "")
                end
                if not seen[normalized] then
                  table.insert(search_dirs, normalized)
                  seen[normalized] = true
                end
              end
            end

            add_search_dir(config.cwd)
            add_search_dir(vim.fn.expand("%:p:h"))
            add_search_dir(vim.fn.getcwd())

            local project_dir
            for _, search_dir in ipairs(search_dirs) do
              local _, found_dir = vim.g.find_godot_project(search_dir)
              if found_dir then
                project_dir = found_dir
                break
              end
            end

            project_dir = project_dir or vim.fn.getcwd()
            local godot_executable = os.getenv("GODOT") or "godot"

            on_config({
              type = "executable",
              command = "${lib.getExe pkgs.netcoredbg}",
              args = {
                "--interpreter=vscode",
                "--",
                godot_executable,
                "--path",
                project_dir,
                "--verbose"
              },
            })
          end
        '';
      };

      configurations =
        let
          godot-launch-config = {
            type = "godot";
            name = "Godot: Launch Game";
            request = "launch";
            program = "";
            cwd = "\${workspaceFolder}";
          };

          godot-attach-config = {
            type = "coreclr";
            name = "Godot: Attach to Process";
            request = "attach";
            processId.__raw = "require('dap.utils').pick_process";
          };
        in
        {
          cs = [
            godot-launch-config
            godot-attach-config
          ];
        };
    };
  };
}
