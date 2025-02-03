{
  plugins = {
    # lazy.enable = true;
    snacks = {
      enable = true;

      settings = {
        dashboard = {
          enabled = true;

          sections = [
            {
              header = ''
                ██╗  ██╗██╗  ██╗ █████╗ ███╗   ██╗███████╗██╗     ██╗██╗   ██╗██╗███╗   ███╗
                ██║ ██╔╝██║  ██║██╔══██╗████╗  ██║██╔════╝██║     ██║██║   ██║██║████╗ ████║
                █████╔╝ ███████║███████║██╔██╗ ██║█████╗  ██║     ██║██║   ██║██║██╔████╔██║
                ██╔═██╗ ██╔══██║██╔══██║██║╚██╗██║██╔══╝  ██║     ██║╚██╗ ██╔╝██║██║╚██╔╝██║
                ██║  ██╗██║  ██║██║  ██║██║ ╚████║███████╗███████╗██║ ╚████╔╝ ██║██║ ╚═╝ ██║
                ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
              '';
            }
            {
              icon = " ";
              title = "Keymaps";
              section = "keys";
              gap = 1;
              padding = 1;
            }
            {
              icon = " ";
              title = "Recent Files";
              __unkeyed-1.__raw = "require('snacks').dashboard.sections.recent_files({cwd = true})";
              gap = 1;
              padding = 1;
            }
            {
              icon = " ";
              title = "Projects";
              section = "projects";
              gap = 1;
              padding = 1;
            }
            {
              pane = 2;
              section = "terminal";
              cmd = "colorscript -e square";
              height = 5;
              padding = 2;
            }
            {
              pane = 2;
              icon = " ";
              desc = "Browse Repo";
              padding = 1;
              key = "b";
              action.__raw = ''
                function()
                  Snacks.gitbrowse()
                end'';
            }
            {
              __raw = ''
                function()
                  local in_git = Snacks.git.get_root() ~= nil
                  local cmds = {
                    {
                      title = "Notifications",
                      cmd = "gh notify -s -a -n5",
                      action = function()
                        vim.ui.open("https://github.com/notifications")
                      end,
                      key = "N",
                      icon = " ",
                      height = 5,
                      enabled = true,
                    },
                    {
                      title = "Open Issues",
                      cmd = "gh issue list -L 3",
                      key = "i",
                      action = function()
                        vim.fn.jobstart("gh issue list --web", { detach = true })
                      end,
                      icon = " ",
                      height = 7,
                    },
                    {
                      icon = " ",
                      title = "Open PRs",
                      cmd = "gh pr list -L 3",
                      key = "p",
                      action = function()
                        vim.fn.jobstart("gh pr list --web", { detach = true })
                      end,
                      height = 7,
                    },
                    {
                      icon = " ",
                      title = "Git Status",
                      cmd = "git --no-pager diff --stat -B -M -C",
                      height = 10,
                    },
                  }
                  return vim.tbl_map(function(cmd)
                    return vim.tbl_extend("force", {
                      pane = 2,
                      section = "terminal",
                      enabled = in_git,
                      padding = 1,
                      ttl = 5 * 60,
                      indent = 3,
                    }, cmd)
                  end, cmds)
                end
              '';
            }
            # NOTE: requires lazy.nvim
            # { section = "startup"; }
          ];
        };
      };
    };
  };
}
