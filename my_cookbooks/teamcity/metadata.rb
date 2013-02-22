name "teamcity"
version "0.0.0"

%w{java runit}.each do |cookbook|
    depends cookbook
end
