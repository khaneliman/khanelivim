{ config, lib, ... }:
{
  plugins = {
    flash = {
      enable = true;

      settings = {
        search = {
          exclude = [
            "notify"
            "cmp_menu"
            "noice"
            "flash_prompt"
            # "NeogitStatus"
            {
              __raw = ''
                function(win)
                  -- exclude non-focusable windows
                  return not vim.api.nvim_win_get_config(win).focusable
                end
              '';
            }
          ];
        };
      };
    };
  };

  keymaps = lib.mkIf config.plugins.flash.enable [
    {
      key = "s";
      action.__raw = ''function() require("flash").jump() end'';
      mode = [
        "n"
        "x"
        "o"
      ];
      options.desc = "Flash";
    }
    {
      key = "S";
      action.__raw = ''function() require("flash").treesitter() end'';
      mode = [
        "n"
        "x"
        "o"
      ];
      options.desc = "Flash Treesitter";
    }
    {
      key = "r";
      action.__raw = ''function() require("flash").remote() end'';
      mode = [
        "o"
      ];
      options.desc = "Remote Flash";
    }
    {
      key = "R";
      action.__raw = ''function() require("flash").treesitter_search() end'';
      mode = [
        "o"
      ];
      options.desc = "Treesitter Search";
    }
    {
      key = "f";
      mode = [
        "n"
        "x"
        "o"
      ];
      action.__raw = ''
        function()
            require("flash").jump(
                {
                    search = {mode = "search"},
                    label = {
                        after = false,
                        before = {0, 0},
                        uppercase = false,
                        format = function(opts)
                            -- always show first and second label
                            return {
                                {opts.match.label1, "FlashMatch"},
                                {opts.match.label2, "FlashLabel"}
                            }
                        end
                    },
                    pattern = [[\<]],
                    action = function(match, state)
                        state:hide()
                        require("flash").jump(
                            {
                                search = {max_length = 0},
                                highlight = {matches = false},
                                label = {format = format},
                                matcher = function(win)
                                    -- limit matches to the current label
                                    return vim.tbl_filter(
                                        function(m)
                                            return m.label == match.label and m.win == win
                                        end,
                                        state.results
                                    )
                                end,
                                labeler = function(matches)
                                    for _, m in ipairs(matches) do
                                        m.label = m.label2 -- use the second label
                                    end
                                end
                            }
                        )
                    end,
                    labeler = function(matches, state)
                        local labels = state:labels()
                        for m, match in ipairs(matches) do
                            match.label1 = labels[math.floor((m - 1) / #labels) + 1]
                            match.label2 = labels[(m - 1) % #labels + 1]
                            match.label = match.label1
                        end
                    end
                }
            )
          end
      '';
      options.desc = "Flash hop";
    }
    {
      key = "gl";
      action.__raw = ''
        function()
          require("flash").jump {
            search = { mode = 'search', max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = '^',
          }
        end
      '';
      mode = [
        "n"
        "x"
        "o"
      ];
      options.desc = "Flash Line";
    }
    # { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  ];

}
