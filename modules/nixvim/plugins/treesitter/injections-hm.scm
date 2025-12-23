;; extends

;; =============================================================================
;; SHELL/BASH STRINGS
;; Matches: *Extra, *Init, activation script (anywhere in path)
;; =============================================================================
(binding
  attrpath: (attrpath (identifier) @name .)
  expression: [
    ; 1. Direct strings
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)

    ; 2. Function wrappers (single level)
    (apply_expression argument: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ])

    ; 3. Nested function wrappers (up to 3 levels deep)
    (apply_expression argument: (parenthesized_expression (apply_expression argument: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
      (parenthesized_expression (apply_expression argument: [
         (string_expression (string_fragment) @injection.content)
         (indented_string_expression (string_fragment) @injection.content)
      ]))
    ])))

    ; 4. Lists (direct strings)
    (list_expression [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ])

    ; 5. Lists with function wrappers
    (apply_expression argument: (list_expression [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ]))

    ; 6. Lists with nested wrappers
    (apply_expression argument: (list_expression [
      (parenthesized_expression (apply_expression argument: [
        (string_expression (string_fragment) @injection.content)
        (indented_string_expression (string_fragment) @injection.content)

        ; Recursive: Wrapper -> Wrapper
        (parenthesized_expression (apply_expression argument: [
            (string_expression (string_fragment) @injection.content)
            (indented_string_expression (string_fragment) @injection.content)
        ]))
      ]))
    ]))

    ; 7. Wrapper around List
    (apply_expression argument: (list_expression [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ]))

    ; 8. Wrapper around List with nested wrappers
    (apply_expression argument: (parenthesized_expression (apply_expression argument: (list_expression [
       (string_expression (string_fragment) @injection.content)
       (indented_string_expression (string_fragment) @injection.content)
       (parenthesized_expression (apply_expression argument: [
         (string_expression (string_fragment) @injection.content)
         (indented_string_expression (string_fragment) @injection.content)
         (parenthesized_expression (apply_expression argument: [
            (string_expression (string_fragment) @injection.content)
            (indented_string_expression (string_fragment) @injection.content)
         ]))
       ]))
    ]))))

    ; Let expressions
    (let_expression body: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ])
  ]
  (#any-of? @name
    "activationCleanupScript"
    "activationScript"
    "backupCmd"
    "bashrcExtra"
    "buildScript"
    "checkCmd"
    "cleanScript"
    "completionInit"
    "endScript"
    "envExtra"
    "extraModprobeConfig"
    "fmtCmd"
    "forgetCmd"
    "initExtra"
    "initExtraBeforeCompInit"
    "initExtraFirst"
    "interactiveShellInit"
    "loginExtra"
    "loginShellInit"
    "logoutExtra"
    "onChange"
    "postInstall"
    "preFixup"
    "postFixup"
    "profileExtra"
    "runCmd"
    "shellInit"
    "startScript"
    "testScript"
    "updateScript")
  (#set! injection.language "bash"))

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
