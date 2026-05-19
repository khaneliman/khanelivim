;; =============================================================================
;; SHELL ALIASES
;; Consolidated block for all variants
;; =============================================================================
(binding
  attrpath: (attrpath (identifier) @name .)
  expression: [
    ; 1. Direct: shellAliases = { ... }
    (attrset_expression
      (binding_set (binding expression: [
          (string_expression (string_fragment) @injection.content)
          (indented_string_expression (string_fragment) @injection.content)
          (apply_expression argument: (list_expression [
             (string_expression (string_fragment) @injection.content)
             (indented_string_expression (string_fragment) @injection.content)
          ]))
      ]))
    )

    ; 2. Wrapped: shellAliases = mkIf true { ... }
    (apply_expression argument: (attrset_expression
      (binding_set (binding expression: [
          (string_expression (string_fragment) @injection.content)
          (indented_string_expression (string_fragment) @injection.content)
          (apply_expression argument: [
             (string_expression (string_fragment) @injection.content)
             (indented_string_expression (string_fragment) @injection.content)
          ])
          (apply_expression argument: (list_expression [
             (string_expression (string_fragment) @injection.content)
             (indented_string_expression (string_fragment) @injection.content)
          ]))
      ]))
    ))

    ; 3. List/Merge: shellAliases = mkMerge [ ... ]
    (apply_expression argument: (list_expression [
      (attrset_expression
        (binding_set (binding expression: [
            (string_expression (string_fragment) @injection.content)
            (indented_string_expression (string_fragment) @injection.content)
            (apply_expression argument: (list_expression [
               (string_expression (string_fragment) @injection.content)
               (indented_string_expression (string_fragment) @injection.content)
            ]))
        ]))
      )
      (parenthesized_expression (apply_expression argument: (attrset_expression
        (binding_set (binding expression: [
            (string_expression (string_fragment) @injection.content)
            (indented_string_expression (string_fragment) @injection.content)
            (apply_expression argument: [
               (string_expression (string_fragment) @injection.content)
               (indented_string_expression (string_fragment) @injection.content)
            ])
            (apply_expression argument: (list_expression [
               (string_expression (string_fragment) @injection.content)
               (indented_string_expression (string_fragment) @injection.content)
            ]))
        ]))
      )))
    ]))

    ; 4. Update Operator: shellAliases = { ... } // ...
    (binary_expression
      left: (attrset_expression
        (binding_set (binding expression: [
          (string_expression (string_fragment) @injection.content)
          (indented_string_expression (string_fragment) @injection.content)
          (apply_expression argument: (list_expression [
             (string_expression (string_fragment) @injection.content)
             (indented_string_expression (string_fragment) @injection.content)
          ]))
        ]))
      )
    )
    (binary_expression
      right: (attrset_expression
        (binding_set (binding expression: [
          (string_expression (string_fragment) @injection.content)
          (indented_string_expression (string_fragment) @injection.content)
          (apply_expression argument: (list_expression [
             (string_expression (string_fragment) @injection.content)
             (indented_string_expression (string_fragment) @injection.content)
          ]))
        ]))
      )
    )
    (binary_expression
      left: (binary_expression
        left: (attrset_expression
          (binding_set (binding expression: [
            (string_expression (string_fragment) @injection.content)
            (indented_string_expression (string_fragment) @injection.content)
            (apply_expression argument: (list_expression [
               (string_expression (string_fragment) @injection.content)
               (indented_string_expression (string_fragment) @injection.content)
            ]))
          ]))
        )
      )
    )
    (binary_expression
      left: (binary_expression
        right: (attrset_expression
          (binding_set (binding expression: [
            (string_expression (string_fragment) @injection.content)
            (indented_string_expression (string_fragment) @injection.content)
            (apply_expression argument: (list_expression [
               (string_expression (string_fragment) @injection.content)
               (indented_string_expression (string_fragment) @injection.content)
            ]))
          ]))
        )
      )
    )

    ; 5. Function Application (foldl style)
    (apply_expression
      function: (apply_expression
        argument: (attrset_expression
          (binding_set (binding expression: [
            (string_expression (string_fragment) @injection.content)
            (indented_string_expression (string_fragment) @injection.content)
            (apply_expression argument: (list_expression [
               (string_expression (string_fragment) @injection.content)
               (indented_string_expression (string_fragment) @injection.content)
            ]))
          ]))
        )
      )
    )
  ]
  (#eq? @name "shellAliases")
  (#set! injection.language "bash"))
