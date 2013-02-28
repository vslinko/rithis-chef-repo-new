name "node-uptime"
version "0.0.0"

%w{nodejs mongodb runit}.each do |cookbook|
    depends cookbook
end
