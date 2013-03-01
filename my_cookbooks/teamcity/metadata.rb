name "teamcity"
version "0.0.1"

%w{java nginx runit}.each do |cookbook|
  depends cookbook
end
