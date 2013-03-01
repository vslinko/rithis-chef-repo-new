name "staging"
version "0.0.0"

%w{nodejs mongodb runit nginx chef-client}.each do |cookbook|
    depends cookbook
end
