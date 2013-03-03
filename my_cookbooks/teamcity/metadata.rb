name "teamcity"
version "0.0.3"

%w{bluepill java nginx}.each do |cookbook|
  depends cookbook
end
