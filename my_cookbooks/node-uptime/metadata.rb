name "node-uptime"
version "0.0.1"

%w{mongodb nodejs runit}.each do |cookbook|
  depends cookbook
end
