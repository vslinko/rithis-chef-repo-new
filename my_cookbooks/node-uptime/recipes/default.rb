include_recipe "mongodb::10gen_repo"
include_recipe "nodejs"
include_recipe "runit"

dir = node["node-uptime"]["dir"]

git dir do
  reference node["node-uptime"]["version"]
  repository "git://github.com/fzaninotto/uptime.git"
  notifies :run, "execute[npm install]", :immediately
end

execute "npm install" do
  cwd dir
  action :nothing
end

template "#{dir}/config/production.yaml" do
  source "production.yaml.erb"
end

runit_service "node-uptime-monitor" do
  default_logger true
end

runit_service "node-uptime-app" do
  default_logger true
end
