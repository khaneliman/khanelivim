{
  lib,
  ...
}:

{
  # Direct shell-bearing module options.
  test_case_misc_shell_keys = {
    xdg.configFile."nvim/init.lua".onChange = ''
      echo "Reloading Neovim..."
    '';

    system.activationScripts.postInstall = ''
      echo "Post install script"
    '';
  };

  # Deeply nested shell strings behind module helper wrappers.
  test_case_deep_nesting = {
    programs.zsh = {
      interactiveShellInit = lib.mkMerge [
        (lib.mkIf true (
          lib.mkOrder 100 ''
            echo "Initializing..."
          ''
        ))
      ];
    };
  };
}
