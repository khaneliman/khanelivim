; Method and local function bodies
(method_declaration
  body: (block) @fold)

(local_function_statement
  body: (block) @fold)

; Constructor and destructor bodies
(constructor_declaration
  body: (block) @fold)

(destructor_declaration
  body: (block) @fold)

; Property and accessor bodies
(accessor_declaration
  body: (block) @fold)

; Lambda bodies
(lambda_expression
  body: (block) @fold)
