{
  plugins.ts-comments = {
    enable = true;

    lazyLoad.settings.event = "DeferredUIEnter";

    settings = {
      lang = {
        astro = "<!-- %s -->";
        axaml = "<!-- %s -->";
        blueprint = "// %s";
        c = "// %s";
        c_sharp = "// %s";
        clojure = [
          ";; %s"
          "; %s"
        ];
        cpp = "// %s";
        cs_project = "<!-- %s -->";
        cue = "// %s";
        fsharp = "// %s";
        fsharp_project = "<!-- %s -->";
        gleam = "// %s";
        glimmer = "{{! %s }}";
        graphql = "# %s";
        handlebars = "{{! %s }}";
        hcl = "# %s";
        html = "<!-- %s -->";
        hyprlang = "# %s";
        ini = "; %s";
        ipynb = "# %s";
        javascript = {
          __unkeyed-1 = "// %s";
          __unkeyed-2 = "/* %s */";
          call_expression = "// %s";
          jsx_attribute = "// %s";
          jsx_element = "{/* %s */}";
          jsx_fragment = "{/* %s */}";
          spread_element = "// %s";
          statement_block = "// %s";
        };
        nix = "# %s";
        nu = "# %s";
        php = "// %s";
        rego = "# %s";
        rescript = "// %s";
        rust = [
          "// %s"
          "/* %s */"
        ];
        sql = "-- %s";
        styled = "/* %s */";
        svelte = "<!-- %s -->";
        templ = {
          __unkeyed-1 = "// %s";
          component_block = "<!-- %s -->";
        };
        terraform = "# %s";
        tsx = {
          __unkeyed-1 = "// %s";
          __unkeyed-2 = "/* %s */";
          call_expression = "// %s";
          jsx_attribute = "// %s";
          jsx_element = "{/* %s */}";
          jsx_fragment = "{/* %s */}";
          spread_element = "// %s";
          statement_block = "// %s";
        };
        twig = "{# %s #}";
        typescript = [
          "// %s"
          "/* %s */"
        ];
        vue = "<!-- %s -->";
        xaml = "<!-- %s -->";
      };
    };
  };
}
