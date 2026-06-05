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

  globals = lib.mkIf (!config.plugins.easy-dotnet.enable) {
    dotnet_build_project.__raw = ''
      function()
        local default_path = vim.fn.getcwd() .. '/'

        if vim.g['dotnet_last_proj_path'] ~= nil then
            default_path = vim.g['dotnet_last_proj_path']
        end

        local path = vim.fn.input('Path to your *proj file', default_path, 'file')

        vim.g['dotnet_last_proj_path'] = path

        local cmd = { 'dotnet', 'build', '-c', 'Debug', path }

        print("")
        print('Cmd to execute: ' .. table.concat(cmd, ' '))

        local output = vim.fn.system(cmd)
        local exit_code = vim.v.shell_error

        if exit_code == 0 then
            print('\nBuild: ✔️ ')
        else
            print('\nBuild: ❌ (code: ' .. exit_code .. ')')
            print(output)
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

  plugins = lib.mkIf (!config.plugins.easy-dotnet.enable) {
    dap = {
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
            name = "launch - coreclr";
            request = "launch";
            program.__raw = ''
              function()
                if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
                  vim.g.dotnet_build_project()
                end

                return vim.g.dotnet_get_dll_path()
              end
            '';
            cwd = "\${workspaceFolder}";
          };

          netcoredbg-config = coreclr-config // {
            type = "netcoredbg";
            name = "launch - netcoredbg";
          };
        in
        {
          cs = [
            coreclr-config
            netcoredbg-config
          ];

          fsharp = [
            coreclr-config
            netcoredbg-config
          ];
        };
    };
  };
}
