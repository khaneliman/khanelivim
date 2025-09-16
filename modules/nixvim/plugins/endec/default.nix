{
  plugins.endec = {
    enable = true;

    lazyLoad.settings.event = "DeferredUIEnter";

    settings = {
      keymaps = {
        # Base64
        decode_base64_inplace = "gei";
        vdecode_base64_inplace = "gei";
        decode_base64_popup = "geI";
        vdecode_base64_popup = "geI";
        encode_base64_inplace = "geB";
        vencode_base64_inplace = "geB";

        # Base64 URL
        decode_base64url_inplace = "ges";
        vdecode_base64url_inplace = "ges";
        decode_base64url_popup = "geS";
        vdecode_base64url_popup = "geS";
        encode_base64url_inplace = "geb";
        vencode_base64url_inplace = "geb";

        # URL
        decode_url_inplace = "gel";
        vdecode_url_inplace = "gel";
        decode_url_popup = "geL";
        vdecode_url_popup = "geL";
        encode_url_inplace = "geu";
        vencode_url_inplace = "geu";
      };
    };
  };
}
