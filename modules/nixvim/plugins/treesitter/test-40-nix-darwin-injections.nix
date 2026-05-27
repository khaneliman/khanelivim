{
  lib,
  ...
}:

{
  # activationScripts.<name>.text.
  test_case_activation_script_text = {
    system.activationScripts.networking.text = ''
      echo "Auditing Application Firewall entries..."
    '';
  };

  # activationScripts.<name>.text with wrapper.
  test_case_wrapped_activation_script_text = {
    system.activationScripts.networking.text = lib.mkAfter ''
      echo "Auditing Application Firewall entries..."
    '';
  };

  # activationScripts.<name>.text with interpolated shell snippets.
  test_case_interpolated_activation_script_text = {
    system.activationScripts.networking.text = lib.mkAfter ''
      echo "Auditing Application Firewall entries..."

      ${lib.optionalString true ''
        echo "wrapped inline optionalString body"
      ''}
    '';
  };

  # activationScripts.<name>.text with only an inline optionalString body.
  test_case_inline_optional_string_only = {
    system.activationScripts.networking.text = ''
      ${lib.optionalString true ''
        echo "direct inline optionalString body"
      ''}
    '';
  };

  # Nested activationScripts.<name>.text.
  test_case_nested_activation_script_text = {
    system = {
      activationScripts.networking.text = lib.mkAfter ''
        echo "Configuring PF rules..."
      '';
    };
  };
}
