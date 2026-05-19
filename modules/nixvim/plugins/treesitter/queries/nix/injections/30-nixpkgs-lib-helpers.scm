;; =============================================================================
;; NIXPKGS LIB LANGUAGE HELPERS
;; Matches helpers whose string argument is source/data for another language.
;; =============================================================================
((apply_expression
  function: (select_expression
    expression: (variable_expression name: (identifier) @_lib)
    attrpath: (attrpath) @helper)
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#eq? @_lib "lib")
  (#eq? @helper "generators.mkLuaInline")
  (#set! injection.language "lua"))

((apply_expression
  function: (select_expression
    expression: (variable_expression name: (identifier) @_lib)
    attrpath: (attrpath) @helper)
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#eq? @_lib "lib")
  (#eq? @helper "mkLuaInline")
  (#set! injection.language "lua"))

((apply_expression
  function: (variable_expression name: (identifier) @helper)
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#eq? @helper "mkLuaInline")
  (#set! injection.language "lua"))

((apply_expression
  function: (select_expression
    expression: (variable_expression name: (identifier) @_lib)
    attrpath: (attrpath) @helper)
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#eq? @_lib "lib")
  (#eq? @helper "fromJSON")
  (#set! injection.language "json"))

((apply_expression
  function: (variable_expression name: (identifier) @helper)
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#eq? @helper "fromJSON")
  (#set! injection.language "json"))

((apply_expression
  function: (select_expression
    expression: (variable_expression name: (identifier) @_lib)
    attrpath: (attrpath) @helper)
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#eq? @_lib "lib")
  (#eq? @helper "fromTOML")
  (#set! injection.language "toml"))

((apply_expression
  function: (variable_expression name: (identifier) @helper)
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#eq? @helper "fromTOML")
  (#set! injection.language "toml"))
