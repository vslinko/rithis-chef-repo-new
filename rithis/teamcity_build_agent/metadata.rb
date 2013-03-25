name    "rithis_teamcity_build_agent"
version "0.0.1"

%w{ mongodb nodejs teamcity_server }.each do |cb|
  depends cb
end
