;; =============================================================================
;; NIX-DARWIN
;; =============================================================================

;; system.activationScripts.<name>.text = ''
;;   ...
;; '';
(binding
  attrpath: (attrpath) @activation_script_path
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
  (#match? @activation_script_path "(^|\\.)activationScripts\\.[^.]+\\.text$")
  (#set! injection.language "bash"))

;; system.activationScripts.<name>.text = ''
;;   ${lib.optionalString condition ''
;;     ...
;;   ''}
;; '';
(binding
  attrpath: (attrpath) @activation_script_path
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
  (#match? @activation_script_path "(^|\\.)activationScripts\\.[^.]+\\.text$")
  (#set! injection.language "bash"))
