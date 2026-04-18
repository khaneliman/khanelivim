{ inputs, lib, ... }:
{
  perSystem =
    {
      config,
      pkgs,
      system,
      ...
    }:
    let
      optionsEval = inputs.self.lib.mkNixvimConfig {
        inherit system;
        profile = "standard";
      };
      docsNvimPackage = inputs.self.lib.mkNixvimPackage {
        inherit system;
        profile = "standard";
      };

      khanelivimOptions = pkgs.nixosOptionsDoc {
        options = lib.filterAttrs (name: _: name == "khanelivim") optionsEval.options;
        warningsAreErrors = false;
      };

      profileDescriptions = {
        minimal = "Native-lean base with LSP, treesitter, blink, and minimal UI.";
        basic = "Lean daily driver with yazi, snacks picker, flash, gitsigns, and lualine.";
        standard = "Recommended developer default with AI, git, debugging, search, and core UI.";
        full = "Everything enabled, including optional and overlapping workflows.";
        debug = "Full profile with performance optimizations disabled and debug logging enabled.";
      };

      profiles = builtins.attrNames profileDescriptions;

      mkProfileConfig =
        profile: (inputs.self.lib.mkNixvimConfig { inherit system profile; }).config.khanelivim;

      profileMatrix = lib.genAttrs profiles (
        profile:
        let
          cfg = mkProfileConfig profile;
        in
        {
          description = profileDescriptions.${profile};
          treesitterWhitelist = cfg.performance.treesitter.whitelistMode;
          inherit (cfg.performance) optimizeEnable;
          inherit (cfg.performance) optimizer;

          aiPlugins = cfg.ai.plugins;
          dashboard = cfg.dashboard.tool;
          docsViewers = cfg.documentation.viewers;

          debugAdapters = cfg.debugging.adapters;
          debugUi = cfg.debugging.ui;
          inherit (cfg.git) diffViewer;
          gitIntegrations = cfg.git.integrations;

          picker = cfg.picker.tool;
          inherit (cfg.editor) fileManager;
          inherit (cfg.editor) httpClient;
          inherit (cfg.editor) motion;
          inherit (cfg.editor) rename;
          inherit (cfg.editor) search;
          inherit (cfg.editor) textObjects;

          inherit (cfg.text) comments;
          inherit (cfg.text) markdownRendering;
          inherit (cfg.text) patterns;
          inherit (cfg.text) splitJoin;
          inherit (cfg.text) whitespace;

          inherit (cfg.ui) animations;
          inherit (cfg.ui) bufferline;
          inherit (cfg.ui) commandline;
          inherit (cfg.ui) indentGuides;
          inherit (cfg.ui) keybindingHelp;
          inherit (cfg.ui) notifications;
          inherit (cfg.ui) renamePopup;
          inherit (cfg.ui) signatureHelp;
          inherit (cfg.ui) statusColumn;
          inherit (cfg.ui) statusline;
          inherit (cfg.ui) terminal;

          inherit (cfg.utilities) clipboard;
          inherit (cfg.utilities) screenshots;
          inherit (cfg.utilities) sessions;
        }
      );

      profileMatrixJson = pkgs.writeText "khanelivim-profile-matrix.json" (
        builtins.toJSON {
          inherit profileDescriptions profileMatrix;
        }
      );

      opener = if pkgs.stdenv.isDarwin then "open" else "xdg-open";
      openDocs = pkgs.writeShellScript "open-khanelivim-docs" ''
        path="${config.packages.docs-html}/index.html"
        if ! ${opener} "$path"; then
          echo "Failed to open docs with ${opener}. Docs are at:"
          echo "$path"
        fi
      '';
    in
    {
      packages.docs-html = pkgs.stdenvNoCC.mkDerivation {
        name = "docs-html";
        src = ../docs;
        nativeBuildInputs = [
          pkgs.mdbook
          pkgs.python3
        ];

        buildPhase = ''
          runHook preBuild

          cp ${profileMatrixJson} profile-matrix.json
          cp ${khanelivimOptions.optionsCommonMark} options.md
          mkdir -p "$TMPDIR/keymaps-home" "$TMPDIR/keymaps-state" "$TMPDIR/keymaps-data" "$TMPDIR/keymaps-cache"
          HOME="$TMPDIR/keymaps-home" \
          XDG_STATE_HOME="$TMPDIR/keymaps-state" \
          XDG_DATA_HOME="$TMPDIR/keymaps-data" \
          XDG_CACHE_HOME="$TMPDIR/keymaps-cache" \
          KEYMAPS_OUTPUT="$TMPDIR/keymaps.json" \
          KEYMAPS_SAMPLE_DIR="$TMPDIR/keymap-samples" \
          ${docsNvimPackage}/bin/nvim --headless "+lua dofile('scripts/dump-keymaps.lua')" +qall
          python3 scripts/split-options.py options.md options "<!-- OPTIONS:START -->" "<!-- OPTIONS:END -->"
          python3 scripts/render-profile-matrix.py profile-matrix.json profiles.md
          python3 scripts/render-keymaps.py "$TMPDIR/keymaps.json" keymaps SUMMARY.md "<!-- KEYMAPS:START -->" "<!-- KEYMAPS:END -->"

          mdbook build --dest-dir "$out" .

          mkdir -p "$out/raw"
          cp "$TMPDIR/keymaps.json" "$out/raw/keymaps.json"
          cp options.md "$out/raw/options.md"
          cp profile-matrix.json "$out/raw/profile-matrix.json"
          cp profiles.md "$out/raw/profiles.md"

          runHook postBuild
        '';

        dontInstall = true;
      };

      apps.docs = {
        type = "app";
        program = "${openDocs}";
        meta.description = "Open the generated khanelivim docs in a browser";
      };

      apps.docs-html = config.apps.docs;
    };
}
