{
  lib,
  pkgs,
  ...
}:
{
  extraPackages = with pkgs; [
    netcoredbg
  ];

  globals = {
    dotnet_build_project.__raw = ''
      function()
        local default_path = vim.fn.getcwd() .. '/'

        if vim.g['dotnet_last_proj_path'] ~= nil then
            default_path = vim.g['dotnet_last_proj_path']
        end

        local path = vim.fn.input('Path to your *proj file', default_path, 'file')

        vim.g['dotnet_last_proj_path'] = path

        local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'

        print("")
        print('Cmd to execute: ' .. cmd)

        local f = os.execute(cmd)

        if f == 0 then
            print('\nBuild: ✔️ ')
        else
            print('\nBuild: ❌ (code: ' .. f .. ')')
        end
      end
    '';

    dotnet_get_dll_path.__raw = ''
      function()
        local request = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end

        if vim.g['dotnet_last_dll_path'] == nil then
            vim.g['dotnet_last_dll_path'] = request()
        else
            if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
                vim.g['dotnet_last_dll_path'] = request()
            end
        end

        return vim.g['dotnet_last_dll_path']
      end
    '';
  };

  plugins = {
    dap = {
      enable = true;
      adapters = {
        executables = {
          coreclr = {
            command = lib.getExe pkgs.netcoredbg;
            args = [ "--interpreter=vscode" ];
          };

          netcoredbg = {
            command = lib.getExe pkgs.netcoredbg;
            args = [ "--interpreter=vscode" ];
          };
        };
      };

      configurations =
        let
          coreclr-config = {
            type = "coreclr";
            name = "launch - netcoredbg";
            request = "launch";
            program.__raw = ''
              function()
                if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
                  vim.g.dotnet_build_project()
                end

                return vim.g.dotnet_get_dll_path()
              end
            '';
            cwd = ''''${workspaceFolder}'';
          };

          netcoredb-config = coreclr-config;
        in
        {
          cs = [
            coreclr-config
            netcoredb-config
          ];

          fsharp = [
            coreclr-config
            netcoredb-config
          ];
        };
    };
  };
}
