include_recipe "teamcity::common"
include_recipe "nginx"

template "/opt/TeamCity/conf/server.xml" do
  source "server.xml.erb"
  notifies :restart, "runit_service[teamcity-server]"
end

runit_service "teamcity-server" do
  default_logger true
  action :nothing
end

template "#{node["nginx"]["dir"]}/sites-available/teamcity.rithis.com" do
  source "teamcity.rithis.com.erb"
  notifies :reload, "service[nginx]"
end

nginx_site "teamcity.rithis.com"
