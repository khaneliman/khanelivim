;; =============================================================================
;; NIX-DARWIN
;; =============================================================================

;; system.activationScripts.<name>.text = ''
;;   ...
;; '';
(binding
  attrpath: (attrpath
    (_)*
    (identifier) @activation_scripts
    (identifier) @_script_name
    (identifier) @text .)
  expression: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)

    (apply_expression argument: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ])

    (apply_expression argument: (parenthesized_expression (apply_expression argument: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ])))

    (let_expression body: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ])
  ]
  (#eq? @activation_scripts "activationScripts")
  (#eq? @text "text")
  (#set! injection.language "bash"))

;; system.activationScripts.<name>.text = ''
;;   ${lib.optionalString condition ''
;;     ...
;;   ''}
;; '';
(binding
  attrpath: (attrpath
    (_)*
    (identifier) @activation_scripts
    (identifier) @_script_name
    (identifier) @text .)
  expression: [
    (indented_string_expression
      (interpolation
        expression: (apply_expression
          argument: [
            (string_expression (string_fragment) @injection.content)
            (indented_string_expression (string_fragment) @injection.content)
          ])))

    (apply_expression argument: (indented_string_expression
    (interpolation
      expression: (apply_expression
        argument: [
          (string_expression (string_fragment) @injection.content)
          (indented_string_expression (string_fragment) @injection.content)
        ]))))
  ]
  (#eq? @activation_scripts "activationScripts")
  (#eq? @text "text")
  (#set! injection.language "bash"))
