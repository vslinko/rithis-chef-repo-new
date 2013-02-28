include_recipe "nodejs"
include_recipe "mongodb::10gen_repo"
include_recipe "runit"

dir = node["node-uptime"]["dir"]

git dir do
    reference "v#{node["node-uptime"]["version"]}"
    repository "git://github.com/fzaninotto/uptime.git"
    notifies :run, "execute[npm install]", :immediately
end

execute "npm install" do
    creates "#{dir}/node_modules"
    cwd dir
    action :nothing
end

template "#{dir}/config/production.yaml" do
    source "production.yaml.erb"
end

runit_service "node-uptime-monitor" do
    log false
end

runit_service "node-uptime-app" do
    log false
end
