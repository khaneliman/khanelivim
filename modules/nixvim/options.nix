{
  lib,
  pkgs,
  ...
}:
{
  # Note: The basic clipboard setup below is overridden by vim.g.clipboard in globals
  # to add timeout wrappers that prevent wl-copy from freezing Neovim
  clipboard = {
    register = "unnamedplus";

    providers = {
      wl-copy = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        enable = true;
      };
    };
  };

  colorscheme = "catppuccin";
  colorschemes.catppuccin.enable = true;
  luaLoader.enable = true;

  globals = {
    # Disable useless providers
    loaded_ruby_provider = 0; # Ruby
    loaded_perl_provider = 0; # Perl
    loaded_python_provider = 0; # Python 2

    # Custom toggles for UI features
    disable_diagnostics = false;
    disable_autoformat = false;
    spell_enabled = true;
    colorizing_enabled = false;
    first_buffer_opened = false;
    whitespace_character_enabled = false;

    # Override clipboard provider with timeout wrapper to prevent wl-copy freezes
    # This takes precedence over the clipboard.providers config above
    clipboard = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      name = "wl-clipboard-timeout";
      copy = {
        "+" = [
          "timeout"
          "1"
          "wl-copy"
        ];
        "*" = [
          "timeout"
          "1"
          "wl-copy"
          "--primary"
        ];
      };
      paste = {
        "+" = [
          "timeout"
          "1"
          "wl-paste"
          "--no-newline"
        ];
        "*" = [
          "timeout"
          "1"
          "wl-paste"
          "--primary"
          "--no-newline"
        ];
      };
      cache_enabled = true;
    };
  };

  opts = {
    # Performance & Timing
    updatetime = 100; # CursorHold delay; faster completion and git signs
    lazyredraw = false; # Breaks noice plugin
    synmaxcol = 240; # Disable syntax highlighting for long lines
    timeoutlen = 500; # Key sequence timeout (ms)

    # UI & Appearance
    number = true;
    relativenumber = true;
    cursorline = true;
    cursorcolumn = false;
    signcolumn = "yes";
    colorcolumn = "100";
    laststatus = 3; # Global statusline
    showtabline = 2;
    showmode = false;
    showmatch = true;
    matchtime = 1; # Flash duration in deciseconds
    termguicolors = true;
    winborder = "rounded";

    # Windows & Splits
    splitbelow = true;
    splitright = true;

    # Mouse
    mouse = "a";
    mousemodel = "extend"; # Right-click extends selection

    # Search
    incsearch = true;
    ignorecase = true; # Case-insensitive search
    smartcase = true; # Unless pattern contains uppercase

    # Files & Buffers
    swapfile = false;
    undofile = true;
    autoread = true;
    writebackup = false;
    fileencoding = "utf-8";
    modeline = true; # Scan for editor directives like 'vim: set ft=nix:'
    modelines = 100; # Scan first/last 100 lines for modelines

    # Spelling
    spell = true;
    spelllang = lib.mkDefault [ "en_us" ];

    # Indentation & Formatting
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    autoindent = true;
    breakindent = true;
    copyindent = true;
    preserveindent = true;
    linebreak = true;
    wrap = false;

    # Folding
    foldlevel = 99; # Keep folds open by default
    foldcolumn = "1";
    foldenable = true;
    foldlevelstart = -1; # -1 uses foldlevel value
    fillchars = {
      horiz = "━";
      horizup = "┻";
      horizdown = "┳";
      vert = "┃";
      vertleft = "┫";
      vertright = "┣";
      verthoriz = "╋";

      eob = " ";
      diff = "╱";

      fold = " ";
      foldopen = "";
      foldclose = "";

      msgsep = "‾";
    };

    # Completion & Popup
    pumheight = 10; # Max popup menu items
    infercase = true;

    # Command Line & Messages
    cmdheight = 0; # Hide command line when not in use
    history = 100; # Command history limit
    report = 9001; # Disable "x more/fewer lines" messages

    # Editor Behavior
    virtualedit = "block";
    startofline = true;
    title = true;
  };
}
