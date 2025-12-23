{
  lib,
  pkgs,
  ...
}:

{
  # Namespace 1: Dotted Notation
  test_case_dotted = {
    home.shellAliases = {
      l = "ls -alh";
      ll = "ls -l";
    };
  };

  # Namespace 2: Standard Nesting
  test_case_nested = {
    home = {
      shellAliases = {
        g = "git";
        ga = "git add";
      };
    };
  };

  # Namespace 3: Wrapper around Attribute Set
  test_case_wrapped_attrset = {
    home = lib.mkIf true {
      shellAliases = {
        gs = "git status";
      };
    };
  };

  # Namespace 4: Wrapper around Shell Aliases directly
  test_case_wrapped_aliases = {
    programs.bash.shellAliases = lib.mkIf true {
      gp = "git push";
    };
  };

  # Namespace 5: mkMerge List
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

  # Namespace 6: Update Operator (Level 1)
  test_case_update_op_1 = {
    home.shellAliases = {
      hl = "cat log";
    }
    // {
      other = "echo other";
    };
  };

  # Namespace 7: Update Operator (Level 2/Nested)
  test_case_update_op_2 = {
    home = {
      shellAliases = {
        base = "echo base";
      }
      // {
        extra = "echo extra";
      };
    };
  };

  # Namespace 8: Update Operator with Multi-line Strings
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

  # Namespace 9: Standard Shell Strings (Deeply Nested)
  test_case_deep_nesting = {
    programs.zsh = {
      interactiveShellInit = lib.mkMerge [
        (lib.mkIf true (
          lib.mkOrder 100 ''
            # Deeply nested shell code
            echo "Initializing..."
          ''
        ))
      ];
    };
  };

  # Namespace 10: Misc Keys (onChange, etc.)
  test_case_misc_keys = {
    xdg.configFile."nvim/init.lua".onChange = ''
      echo "Reloading Neovim..."
    '';

    system.activationScripts.postInstall = ''
      echo "Post install script"
    '';
  };

  # Namespace 11: foldl with lib.concatStrings
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
