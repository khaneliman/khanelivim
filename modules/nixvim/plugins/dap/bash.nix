{
  lib,
  pkgs,
  ...
}:
{
  extraPackages =
    with pkgs;
    lib.optionals pkgs.stdenv.isLinux [
      bashdb
    ];

  plugins = {
    dap = {
      adapters = {
        executables = {
          bashdb = lib.mkIf pkgs.stdenv.isLinux { command = lib.getExe pkgs.bashdb; };
        };
      };

      configurations = {
        sh = lib.optionals pkgs.stdenv.isLinux [
          {
            type = "bashdb";
            request = "launch";
            name = "Launch (BashDB)";
            showDebugOutput = true;
            pathBashdb = "${lib.getExe pkgs.bashdb}";
            pathBashdbLib = "${pkgs.bashdb}/share/basdhb/lib/";
            trace = true;
            file = ''''${file}'';
            program = ''''${file}'';
            cwd = ''''${workspaceFolder}'';
            pathCat = "cat";
            pathBash = "${lib.getExe pkgs.bash}";
            pathMkfifo = "mkfifo";
            pathPkill = "pkill";
            args = { };
            env = { };
            terminalKind = "integrated";
          }
        ];
      };

    };
  };

}
