name "node-build-agent"
version "0.0.0"

%w{nodejs mongodb}.each do |cookbook|
    depends cookbook
end
