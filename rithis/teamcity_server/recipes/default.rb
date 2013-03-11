include_recipe "teamcity_server::server"
include_recipe "nginx"

template "#{node["nginx"]["dir"]}/sites-available/teamcity.rithis.com" do
  source "teamcity.rithis.com.erb"
  variables :port => node["teamcity_server"]["server"]["port"]
  notifies :reload, "service[nginx]"
end

nginx_site "teamcity.rithis.com"
