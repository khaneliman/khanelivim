; Function declarations
(function_declaration
  body: (statement_block) @fold)

; Function expressions (const foo = function() {})
(variable_declarator
  value: (function_expression
    body: (statement_block) @fold))

; Arrow functions (const foo = () => {})
(variable_declarator
  value: (arrow_function
    body: (statement_block) @fold))

; Method definitions in objects/classes
(method_definition
  body: (statement_block) @fold)
