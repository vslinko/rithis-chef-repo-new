name "vyacheslav-dotfiles"
version "0.0.0"

%w{git}.each do |cookbook|
    depends cookbook
end
