name "node-build-agent"
version "0.0.1"

%w{mongodb nodejs}.each do |cookbook|
  depends cookbook
end
