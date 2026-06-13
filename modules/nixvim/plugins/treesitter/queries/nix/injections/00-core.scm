;; =============================================================================
;; KHANELIVIM NIX INJECTIONS
;; This file owns the base Nix injection query instead of extending upstream.
;; =============================================================================

;; =============================================================================
;; NIXVIM LUA HELPERS
;; =============================================================================

((apply_expression
  function: [
    (variable_expression name: (identifier) @helper)
    (select_expression attrpath: (attrpath) @helper)
  ]
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#match? @helper "(^|\\.)mkRaw$")
  (#set! injection.language "lua"))

(binding
  attrpath: (attrpath (identifier) @_path)
  expression: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)

    (apply_expression argument: [
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
    ])

    (apply_expression argument: (list_expression [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
      (parenthesized_expression (apply_expression argument: [
         (string_expression (string_fragment) @injection.content)
         (indented_string_expression (string_fragment) @injection.content)
      ]))
    ]))
    (list_expression [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ])

    (let_expression body: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ])
  ]
  (#any-of? @_path "__raw" "extraConfigLua" "extraConfigLuaPre" "extraConfigLuaPost")
  (#set! injection.language "lua"))

(binding
  attrpath: (attrpath (identifier) @_path)
  expression: (attrset_expression (binding_set (binding
    attrpath: (attrpath (identifier) @_nested)
    expression: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)

      (apply_expression argument: [
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
      ])

      (let_expression body: [
        (string_expression (string_fragment) @injection.content)
        (indented_string_expression (string_fragment) @injection.content)
      ])
    ]
    (#any-of? @_nested "pre" "post" "content")
  )))
  (#eq? @_path "luaConfig")
  (#set! injection.language "lua"))

(binding
  attrpath: (attrpath (identifier) @ns (identifier) @name)
  expression: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)

    (apply_expression argument: [
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
    ])

    (let_expression body: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ])
  ]
  (#eq? @ns "luaConfig")
  (#any-of? @name "pre" "post" "content")
  (#set! injection.language "lua"))

(binding
  attrpath: (attrpath (identifier) @_path)
  expression: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)

    (apply_expression argument: [
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
    ])

    (apply_expression argument: (list_expression [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
      (parenthesized_expression (apply_expression argument: [
         (string_expression (string_fragment) @injection.content)
         (indented_string_expression (string_fragment) @injection.content)
      ]))
    ]))

    (let_expression body: [
      (string_expression (string_fragment) @injection.content)
      (indented_string_expression (string_fragment) @injection.content)
    ])
  ]
  (#any-of? @_path "extraConfigVim" "extraConfigVimPre" "extraConfigVimPost")
  (#set! injection.language "vim"))

;; =============================================================================
;; NIXPKGS BUILD HELPERS
;; =============================================================================

((apply_expression
  function: [
    (variable_expression name: (identifier) @_func)
    (select_expression attrpath: (attrpath) @_func)
  ]
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#match? @_func "(^|\\.)match$")
  (#set! injection.language "regex")
  (#set! injection.combined))

(binding
  attrpath: (attrpath (identifier) @_path)
  expression: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ]
  (#match? @_path "^(.*Phase|pre.+|post.+|script)$")
  (#set! injection.language "bash")
  (#set! injection.combined))

(apply_expression
  function: [
    (variable_expression name: (identifier) @_func)
    (select_expression attrpath: (attrpath) @_func)
  ]
  argument: (attrset_expression
    (binding_set
      (binding
        attrpath: (attrpath (identifier) @_path)
        expression: [
          (string_expression (string_fragment) @injection.content)
          (indented_string_expression (string_fragment) @injection.content)
        ])))
  (#match? @_func "(^|\\.)writeShellApplication$")
  (#eq? @_path "text")
  (#set! injection.language "bash")
  (#set! injection.combined))

(apply_expression
  function: (apply_expression
    function: (apply_expression
      function: [
        (variable_expression name: (identifier) @_func)
        (select_expression attrpath: (attrpath) @_func)
      ]))
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ]
  (#match? @_func "(^|\\.)runCommand.*$")
  (#set! injection.language "bash")
  (#set! injection.combined))

((apply_expression
  function: (apply_expression
    function: [
      (variable_expression name: (identifier) @_func)
      (select_expression attrpath: (attrpath) @_func)
    ])
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#match? @_func "(^|\\.)(writeBash|writeDash|writeShellScript).*")
  (#set! injection.language "bash")
  (#set! injection.combined))

((apply_expression
  function: (apply_expression
    function: [
      (variable_expression name: (identifier) @_func)
      (select_expression attrpath: (attrpath) @_func)
    ])
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#match? @_func "(^|\\.)writeFish.*")
  (#set! injection.language "fish")
  (#set! injection.combined))

((apply_expression
  function: (apply_expression
    function: (apply_expression
      function: [
        (variable_expression name: (identifier) @_func)
        (select_expression attrpath: (attrpath) @_func)
      ]))
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#match? @_func "(^|\\.)writeHaskell.*")
  (#set! injection.language "haskell")
  (#set! injection.combined))

((apply_expression
  function: (apply_expression
    function: [
      (variable_expression name: (identifier) @_func)
      (select_expression attrpath: (attrpath) @_func)
    ])
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#match? @_func "(^|\\.)writeJS.*")
  (#set! injection.language "javascript")
  (#set! injection.combined))

((apply_expression
  function: (apply_expression
    function: [
      (variable_expression name: (identifier) @_func)
      (select_expression attrpath: (attrpath) @_func)
    ])
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#match? @_func "(^|\\.)writePerl.*")
  (#set! injection.language "perl")
  (#set! injection.combined))

((apply_expression
  function: (apply_expression
    function: [
      (variable_expression name: (identifier) @_func)
      (select_expression attrpath: (attrpath) @_func)
    ])
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#match? @_func "(^|\\.)writePy.*")
  (#set! injection.language "python")
  (#set! injection.combined))

((apply_expression
  function: (apply_expression
    function: (apply_expression
      function: [
        (variable_expression name: (identifier) @_func)
        (select_expression attrpath: (attrpath) @_func)
      ]))
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#match? @_func "(^|\\.)writePy.*")
  (#set! injection.language "python")
  (#set! injection.combined))

((apply_expression
  function: [
    (variable_expression name: (identifier) @_func)
    (select_expression attrpath: (attrpath) @_func)
  ]
  argument: [
    (string_expression (string_fragment) @injection.content)
    (indented_string_expression (string_fragment) @injection.content)
  ])
  (#match? @_func "(^|\\.)writeRust.*")
  (#set! injection.language "rust")
  (#set! injection.combined))

(apply_expression
  function: [
    (variable_expression name: (identifier) @_func)
    (select_expression attrpath: (attrpath) @_func)
  ]
  argument: (attrset_expression
    (binding_set
      (binding
        attrpath: (attrpath (identifier) @_path)
        expression: [
          (string_expression (string_fragment) @injection.content)
          (indented_string_expression (string_fragment) @injection.content)
        ])))
  (#match? @_func "(^|\\.)(runTest|nixosTest)$")
  (#eq? @_path "testScript")
  (#set! injection.language "python")
  (#set! injection.combined))
