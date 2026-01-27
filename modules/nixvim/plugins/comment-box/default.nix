{ lib, config, ... }:
{
  plugins = {
    comment-box = {
      enable = lib.elem "comment-box" config.khanelivim.text.comments;

      lazyLoad = {
        settings = {
          cmd = [
            # Utils
            "CBd"
            "CBy"
            "CBcatalog"
            # Boxes
            "CBllbox"
            "CBlcbox"
            "CBlrbox"
            "CBclbox"
            "CBccbox"
            "CBcrbox"
            "CBrlbox"
            "CBrcbox"
            "CBrrbox"
            # Lines
            "CBline"
            "CBlline"
            "CBcline"
            "CBrline"
            # Titled Lines
            "CBllline"
            "CBlcline"
            "CBlrline"
            "CBclline"
            "CBccline"
            "CBcrline"
            "CBrlline"
            "CBrcline"
            "CBrrline"
          ];
        };
      };

      settings = {
        # TODO: customize
        #   borders = {
        #     bottom_left = "X";
        #     bottom_right = "X";
        #     top_left = "X";
        #     top_right = "X";
        #   };
        #   box_width = 120;
        #   comment_style = "block";
        #   doc_width = 100;
        #   inner_blank_lines = true;
        #   line_width = 40;
        #   lines = {
        #     line = "*";
        #   };
        #   outer_blank_lines_below = true;
      };
    };

    which-key.settings.spec = lib.mkIf config.plugins.comment-box.enable [
      {
        __unkeyed-1 = "<leader>cb";
        group = "Boxes (left)";
        mode = [
          "n"
          "v"
        ];
      }
      {
        __unkeyed-1 = "<leader>cB";
        group = "Boxes (center/right)";
        mode = [
          "n"
          "v"
        ];
      }
      {
        __unkeyed-1 = "<leader>ct";
        group = "Titled Lines (left)";
        mode = [
          "n"
          "v"
        ];
      }
      {
        __unkeyed-1 = "<leader>cT";
        group = "Titled Lines (center/right)";
        mode = [
          "n"
          "v"
        ];
      }
    ];
  };

  keymaps = lib.mkIf config.plugins.comment-box.enable [
    # ── Utils ─────────────────────────────────────────────────────────────
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cd";
      action = "<cmd>CBd<cr>";
      options = {
        desc = "Delete box/line";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cy";
      action = "<cmd>CBy<cr>";
      options = {
        desc = "Yank content";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>co";
      action = "<cmd>CBcatalog<cr>";
      options = {
        desc = "Open catalog";
      };
    }
    # ── Boxes: Left Aligned ───────────────────────────────────────────────
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cbl";
      action = "<cmd>CBllbox<cr>";
      options = {
        desc = "Box: left/left";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cbc";
      action = "<cmd>CBlcbox<cr>";
      options = {
        desc = "Box: left/center";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cbr";
      action = "<cmd>CBlrbox<cr>";
      options = {
        desc = "Box: left/right";
      };
    }
    # ── Boxes: Centered ───────────────────────────────────────────────────
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cBl";
      action = "<cmd>CBclbox<cr>";
      options = {
        desc = "Box: center/left";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cBc";
      action = "<cmd>CBccbox<cr>";
      options = {
        desc = "Box: center/center";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cBr";
      action = "<cmd>CBcrbox<cr>";
      options = {
        desc = "Box: center/right";
      };
    }
    # ── Boxes: Right Aligned ──────────────────────────────────────────────
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cBL";
      action = "<cmd>CBrlbox<cr>";
      options = {
        desc = "Box: right/left";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cBC";
      action = "<cmd>CBrcbox<cr>";
      options = {
        desc = "Box: right/center";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cBR";
      action = "<cmd>CBrrbox<cr>";
      options = {
        desc = "Box: right/right";
      };
    }
    # ── Lines ─────────────────────────────────────────────────────────────
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cl";
      action = "<cmd>CBline<cr>";
      options = {
        desc = "Line: left";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cL";
      action = "<cmd>CBcline<cr>";
      options = {
        desc = "Line: center";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cr";
      action = "<cmd>CBrline<cr>";
      options = {
        desc = "Line: right";
      };
    }
    # ── Titled Lines: Left Aligned ────────────────────────────────────────
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ctl";
      action = "<cmd>CBllline<cr>";
      options = {
        desc = "Titled line: left/left";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ctc";
      action = "<cmd>CBlcline<cr>";
      options = {
        desc = "Titled line: left/center";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>ctr";
      action = "<cmd>CBlrline<cr>";
      options = {
        desc = "Titled line: left/right";
      };
    }
    # ── Titled Lines: Centered ────────────────────────────────────────────
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cTl";
      action = "<cmd>CBclline<cr>";
      options = {
        desc = "Titled line: center/left";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cTc";
      action = "<cmd>CBccline<cr>";
      options = {
        desc = "Titled line: center/center";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cTr";
      action = "<cmd>CBcrline<cr>";
      options = {
        desc = "Titled line: center/right";
      };
    }
    # ── Titled Lines: Right Aligned ───────────────────────────────────────
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cTL";
      action = "<cmd>CBrlline<cr>";
      options = {
        desc = "Titled line: right/left";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cTC";
      action = "<cmd>CBrcline<cr>";
      options = {
        desc = "Titled line: right/center";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cTR";
      action = "<cmd>CBrrline<cr>";
      options = {
        desc = "Titled line: right/right";
      };
    }
  ];
}
