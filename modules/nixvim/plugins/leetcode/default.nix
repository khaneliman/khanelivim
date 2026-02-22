{ config, lib, ... }:
{
  plugins.leetcode = {
    # leetcode.nvim documentation
    # See: https://github.com/kawre/leetcode.nvim
    enable = true;

    lazyLoad.settings = {
      cmd = [
        "Leet"
      ];
    };

    settings = {
      # NOTE:
      # Language 	lang
      # C++ 	cpp
      # Java 	java
      # Python 	python
      # Python3 	python3
      # C 	c
      # C# 	csharp
      # JavaScript 	javascript
      # TypeScript 	typescript
      # PHP 	php
      # Swift 	swift
      # Kotlin 	kotlin
      # Dart 	dart
      # Go 	golang
      # Ruby 	ruby
      # Scala 	scala
      # Rust 	rust
      # Racket 	racket
      # Erlang 	erlang
      # Elixir 	elixir
      # Bash 	bash
      lang = "rust";
    };
  };

  keymaps = lib.optionals config.plugins.leetcode.enable [
    {
      mode = "n";
      key = "<leader>L";
      action = "<cmd>Leet<CR>";
      options = {
        desc = "Leet code";
      };
    }
    # NOTE: just seems to quit neovim.
    # {
    #   mode = "n";
    #   key = "<leader>Lq";
    #   action = "<cmd>Leet exit<CR>";
    #   options = {
    #     desc = "Exit Leet Code";
    #   };
    # }
  ];
}
