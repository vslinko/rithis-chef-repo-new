name "youtrack"
version "0.0.0"

%w{java nginx runit}.each do |cookbook|
  depends cookbook
end
