name    "rithis_teamcity_server"
version "0.0.0"

%w{ nginx teamcity_server }.each do |cb|
  depends cb
end
