; Function bodies
(binding
  attrpath: (attrpath) @binding_path
  expression: (function_expression
    body: (_) @fold)
  ; ignore top level flake outputs
  (#not-match? @binding_path "^outputs$")
  (#not-match? @binding_path "^perSystem"))
