name "staging"
version "0.0.2"

%w{chef-client mongodb nginx nodejs runit}.each do |cookbook|
  depends cookbook
end
