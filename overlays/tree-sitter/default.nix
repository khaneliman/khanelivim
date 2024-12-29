{ channels, ... }:
_self: _super: {
  inherit (channels.nixpkgs-tree-sitter) tree-sitter;
}
