{
  config,
  lib,
  self,
  system,
  ...
}:
let
  cfg = config.plugins.resolve;
  usesLegacyIntegration = lib.elem "git-conflict" config.khanelivim.git.integrations;
  isSelected = usesLegacyIntegration || lib.elem "resolve" config.khanelivim.git.integrations;
  luaConfig = ''
    require('khanelivim.resolve').setup(
      ${lib.generators.toLua { } cfg.settings},
      ${lib.boolToString cfg.disableDiagnostics}
    )
  '';
  commands = [
    "GitConflictChooseBase"
    "GitConflictChooseBoth"
    "GitConflictChooseNone"
    "GitConflictChooseOurs"
    "GitConflictChooseTheirs"
    "GitConflictListQf"
    "GitConflictNextConflict"
    "GitConflictPrevConflict"
    "GitConflictRefresh"
    "ResolveBase"
    "ResolveBoth"
    "ResolveBothReverse"
    "ResolveDetect"
    "ResolveDiffBoth"
    "ResolveDiffOurs"
    "ResolveDiffOursTheirs"
    "ResolveDiffTheirs"
    "ResolveDiffTheirsOurs"
    "ResolveList"
    "ResolveNext"
    "ResolveNone"
    "ResolveOurs"
    "ResolvePrev"
    "ResolveTheirs"
  ];
in
{
  options.plugins.resolve = {
    enable = lib.mkEnableOption "resolve.nvim" // {
      default = isSelected;
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${system}.resolve;
      defaultText = lib.literalExpression "self.packages.\${system}.resolve";
      description = "The resolve.nvim package to use.";
    };

    disableDiagnostics = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to disable diagnostics in buffers with unresolved conflicts.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = ''
        Configuration passed to `require('resolve').setup(...)`.

        See <https://github.com/spacedentist/resolve.nvim>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.optional usesLegacyIntegration ''
      The "git-conflict" integration now enables resolve.nvim as a compatibility alias.
      Use "resolve" in khanelivim.git.integrations instead.
    '';

    extraFiles."lua/khanelivim/resolve.lua".source = ./resolve.lua;
    extraConfigLua = lib.mkIf (!config.plugins.lz-n.enable) luaConfig;

    extraPlugins = [
      {
        plugin = cfg.package;
        optional = config.plugins.lz-n.enable;
      }
    ];

    plugins.lz-n.plugins = lib.mkIf config.plugins.lz-n.enable [
      {
        __unkeyed-1 = "resolve.nvim";
        event = [
          "BufReadPost"
          "BufNewFile"
        ];
        cmd = commands;
        after.__raw = ''
          function()
            ${luaConfig}
          end
        '';
      }
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>gc]";
        action = "<cmd>ResolveNext<CR>";
        options.desc = "Next";
      }
      {
        mode = "n";
        key = "<leader>gc[";
        action = "<cmd>ResolvePrev<CR>";
        options.desc = "Prev";
      }
      {
        mode = "n";
        key = "<leader>gcr";
        action = "<cmd>ResolveDetect<CR>";
        options.desc = "Refresh";
      }
      {
        mode = "n";
        key = "<leader>gcb";
        action = "<cmd>ResolveBase<CR>";
        options.desc = "Choose Base";
      }
      {
        mode = "n";
        key = "<leader>gcB";
        action = "<cmd>ResolveBoth<CR>";
        options.desc = "Choose Both";
      }
      {
        mode = "n";
        key = "<leader>gct";
        action = "<cmd>ResolveTheirs<CR>";
        options.desc = "Choose Theirs";
      }
      {
        mode = "n";
        key = "<leader>gco";
        action = "<cmd>ResolveOurs<CR>";
        options.desc = "Choose Ours";
      }
      {
        mode = "n";
        key = "<leader>gcn";
        action = "<cmd>ResolveNone<CR>";
        options.desc = "Choose None";
      }
      {
        mode = "n";
        key = "<leader>gcl";
        action = "<cmd>ResolveList<CR>";
        options.desc = "List";
      }
    ];
  };
}
