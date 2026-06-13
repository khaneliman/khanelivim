{
  lib,
  pkgs,
  ...
}:

{
  test_case_nixvim_core = {
    rawLua = lib.mkRaw ''
      vim.opt.number = true
    '';

    extraConfigLua = ''
      vim.g.khanelivim_core_query = true
    '';

    luaConfig = {
      pre = ''
        vim.api.nvim_create_user_command("CoreQuery", function() end, {})
      '';
    };

    extraConfigVim = ''
      set number
    '';
  };

  test_case_nixpkgs_core = {
    regex = builtins.match "^[a-z]+$" "khanelivim";

    installPhase = ''
      echo "installing"
    '';

    customPhase = ''
      echo "custom phase"
    '';

    preCustom = ''
      echo "pre custom"
    '';

    postCustom = ''
      echo "post custom"
    '';

    script = ''
      echo "script hook"
    '';

    shellScript = pkgs.writeShellScript "khanelivim-test" ''
      echo "shell script"
    '';

    shellApplication = pkgs.writeShellApplication {
      name = "khanelivim-test";
      text = ''
        echo "shell application"
      '';
    };

    pythonTool = pkgs.writers.writePython3 "khanelivim-test" { } ''
      print("python")
    '';
  };

}
