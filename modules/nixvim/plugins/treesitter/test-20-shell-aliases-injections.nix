{
  lib,
  pkgs,
  ...
}:

{
  # Dotted notation.
  test_case_dotted = {
    home.shellAliases = {
      l = "ls -alh";
      ll = "ls -l";
    };
  };

  # Standard nesting.
  test_case_nested = {
    home = {
      shellAliases = {
        g = "git";
        ga = "git add";
      };
    };
  };

  # Wrapper around attribute set.
  test_case_wrapped_attrset = {
    home = lib.mkIf true {
      shellAliases = {
        gs = "git status";
      };
    };
  };

  # Wrapper around shellAliases directly.
  test_case_wrapped_aliases = {
    programs.bash.shellAliases = lib.mkIf true {
      gp = "git push";
    };
  };

  # mkMerge list.
  test_case_merge = {
    programs.zsh.shellAliases = lib.mkMerge [
      {
        ll = "ls -l";
      }
      (lib.mkIf true {
        gc = "git commit";
      })
    ];
  };

  # Update operator.
  test_case_update_op = {
    home.shellAliases = {
      hl = "cat log";
    }
    // {
      other = "echo other";
    };
  };

  # Nested update operator.
  test_case_nested_update_op = {
    home = {
      shellAliases = {
        base = "echo base";
      }
      // {
        extra = "echo extra";
      };
    };
  };

  # Update operator with multi-line strings.
  test_case_update_op_multiline = {
    config = lib.mkIf true {
      home.shellAliases = {
        complex = ''
          if [ -d .git ]; then
            git status
          fi
        '';
      };
    };
  };

  # foldl with lib.concatStrings.
  test_case_foldl = {
    home = {
      shellAliases =
        lib.foldl (aliases: system: aliases // { "ssh-''${system}" = "ssh ''${system} -t tmux a"; })
          {
            ssh-list-perm-user = ''find ~/.ssh -exec stat -c "%a %n" {} \;'';

            ssh-perm-user = lib.concatStrings [
              ''${lib.getExe' pkgs.findutils "find"} ~/.ssh -type f -exec chmod 600 {} \;;''
              ''${lib.getExe' pkgs.findutils "find"} ~/.ssh -type d -exec chmod 700 {} \;;''
              ''${lib.getExe' pkgs.findutils "find"} ~/.ssh -type f -name "*.pub" -exec chmod 644 {} \;''
            ];

            ssh-list-perm-system = ''sudo find /etc/ssh -exec stat -c "%a %n" {} \;'';

            ssh-perm-system = lib.concatStrings [
              ''sudo ${lib.getExe' pkgs.findutils "find"} /etc/ssh -type f -exec chmod 600 {} \;;''
              ''sudo ${lib.getExe' pkgs.findutils "find"} /etc/ssh -type d -exec chmod 700 {} \;;''
              ''sudo ${lib.getExe' pkgs.findutils "find"} /etc/ssh -type f -name "*.pub" -exec chmod 644 {} \;''
            ];
          }
          (builtins.attrNames { });
    };
  };
}
