name "node-build-agent"
version "0.0.2"

%w{mongodb nodejs teamcity}.each do |cookbook|
  depends cookbook
end
