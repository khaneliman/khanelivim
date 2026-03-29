{
  extraFiles = {
    "lua/khanelivim/tooling_info.lua".source = ./lua/khanelivim/tooling_info.lua;
    "lua/khanelivim/web_tools.lua".source = ./lua/khanelivim/web_tools.lua;
  };

  # Just a small boolean function to convert a boolean to a string
  extraConfigLuaPre = ''
    function bool2str(bool) return bool and "on" or "off" end
  '';
}
