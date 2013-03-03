name "youtrack"
version "0.0.1"

%w{bluepill java nginx}.each do |cookbook|
  depends cookbook
end
