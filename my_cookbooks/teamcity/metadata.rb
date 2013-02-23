name "teamcity"
version "0.0.0"

%w{java runit nginx}.each do |cookbook|
    depends cookbook
end
