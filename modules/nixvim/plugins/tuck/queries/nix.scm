; Function bodies
(binding
  expression: [
    (if_expression)
    (let_expression)
    (function_expression)
    (indented_string_expression)
  ] @fold)

; Multi-line Nix strings
(apply_expression
  argument: (indented_string_expression) @fold)

; Multi-line lists
(list_expression) @fold
