{ lib, config, ... }:
{
  plugins = {
    fzf-lua = {
      enable = true;
      profile = "telescope";

      # TODO: Figure out why it's not using profile
      # lazyLoad.settings.cmd = "FzfLua";

      settings = {
        oldfiles = {
          cwd_only = true;
        };
        winopts = {
          preview = {
            default = "bat";
          };
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.fzf-lua.enable [
    {
      mode = "n";
      key = "<leader>dB";
      action = ''<cmd>FzfLua dap_breakpoints<CR>'';
      options = {
        desc = "Find dap breakpoints";
      };
    }
    {
      mode = "n";
      key = "<leader>dC";
      action = ''<cmd>FzfLua dap_commands<CR>'';
      options = {
        desc = "Find dap commands";
      };
    }
    {
      mode = "n";
      key = "<leader>df";
      action = ''<cmd>FzfLua dap_frames<CR>'';
      options = {
        desc = "Find dap frames";
      };
    }
    {
      mode = "n";
      key = "<leader>dv";
      action = ''<cmd>FzfLua dap_variables<CR>'';
      options = {
        desc = "Find dap variables";
      };
    }
    {
      mode = "n";
      key = "<leader>f'";
      action = ''<cmd>FzfLua marks<CR>'';
      options = {
        desc = "Find marks";
      };
    }
    {
      mode = "n";
      key = "<leader>f/";
      action = ''<cmd>FzfLua blines<CR>'';
      options = {
        desc = "Fuzzy find in current buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>f?";
      action = ''<cmd>FzfLua lines<CR>'';
      options = {
        desc = "Fuzzy find in open buffers";
      };
    }
    {
      mode = "n";
      key = "<leader>f<CR>";
      action = ''<cmd>FzfLua resume<CR>'';
      options = {
        desc = "Resume find";
      };
    }
    {
      mode = "n";
      key = "<leader>fa";
      action = ''<cmd>FzfLua autocmds<CR>'';
      options = {
        desc = "Find autocmds";
      };
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = ''<cmd>FzfLua buffers<CR>'';
      options = {
        desc = "Find buffers";
      };
    }
    {
      mode = "n";
      key = "<leader>fc";
      action = ''<cmd>FzfLua commands<CR>'';
      options = {
        desc = "Find commands";
      };
    }
    {
      mode = "n";
      key = "<leader>fC";
      action.__raw = ''
        function()
          require("fzf-lua").files {
            prompt_title = "Config Files",
            cwd = vim.fn.stdpath "config",
            follow = true,
          }
        end
      '';
      options = {
        desc = "Find config files";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>fd";
      action = ''<cmd>FzfLua diagnostics_document<CR>'';
      options = {
        desc = "Find buffer diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>fD";
      action = ''<cmd>FzfLua diagnostics_workspace<CR>'';
      options = {
        desc = "Find workspace diagnostics";
      };
    }
    {
      mode = "n";
      key = "<leader>ff";
      action = ''<cmd>FzfLua files<CR>'';
      options = {
        desc = "Find files";
      };
    }
    {
      mode = "n";
      key = "<leader>fh";
      action = ''<cmd>FzfLua helptags<CR>'';
      options = {
        desc = "Find help tags";
      };
    }
    {
      mode = "n";
      key = "<leader>fk";
      action = ''<cmd>FzfLua keymaps<CR>'';
      options = {
        desc = "Find keymaps";
      };
    }
    {
      mode = "n";
      key = "<leader>fm";
      action = ''<cmd>FzfLua manpages<CR>'';
      options = {
        desc = "Find man pages";
      };
    }
    {
      mode = "n";
      key = "<leader>fo";
      action = ''<cmd>FzfLua oldfiles<CR>'';
      options = {
        desc = "Find old files";
      };
    }
    {
      mode = "n";
      key = "<leader>fq";
      action = ''<cmd>FzfLua quickfix<CR>'';
      options = {
        desc = "Find quickfix";
      };
    }
    {
      mode = "n";
      key = "<leader>fr";
      action = ''<cmd>FzfLua registers<CR>'';
      options = {
        desc = "Find registers";
      };
    }
    {
      mode = "n";
      key = "<leader>fs";
      action = ''<cmd>FzfLua lsp_document_symbols<CR>'';
      options = {
        desc = "Find lsp document symbols";
      };
    }
    {
      mode = "n";
      key = "<leader>fS";
      action = ''<cmd>FzfLua spell_suggest<CR>'';
      options = {
        desc = "Find spelling suggestions";
      };
    }
    {
      mode = "n";
      key = "<leader>fT";
      action = ''<cmd>FzfLua colorschemes<CR>'';
      options = {
        desc = "Find theme";
      };
    }
    {
      mode = "n";
      key = "<leader>fw";
      action = "<cmd>FzfLua live_grep<CR>";
      options = {
        desc = "Live grep";
      };
    }
    {
      mode = "n";
      key = "<leader>gB";
      action = ''<cmd>FzfLua git_branches<CR>'';
      options = {
        desc = "Find git branches";
      };
    }
    {
      mode = "n";
      key = "<leader>gC";
      action = ''<cmd>FzfLua git_commits<CR>'';
      options = {
        desc = "Find git commits";
      };
    }
    {
      mode = "n";
      key = "<leader>gs";
      action = ''<cmd>FzfLua git_status<CR>'';
      options = {
        desc = "Find git status";
      };
    }
    {
      mode = "n";
      key = "<leader>gS";
      action = ''<cmd>FzfLua git_stash<CR>'';
      options = {
        desc = "Find git stashes";
      };
    }
    {
      mode = "n";
      key = "<leader>la";
      action = ''<cmd>FzfLua lsp_code_actions<CR>'';
      options = {
        desc = "Code Action";
      };
    }
  ];
}
