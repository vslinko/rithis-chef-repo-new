include_recipe "teamcity::common"
include_recipe "nginx"

template "/opt/TeamCity/conf/server.xml" do
  source "server.xml.erb"
  notifies :restart, "bluepill_service[teamcity-server]"
end

template "#{node["bluepill"]["conf_dir"]}/teamcity-server.pill" do
  source "teamcity-server.pill.erb"
end

bluepill_service "teamcity-server" do
  action [:enable, :load, :start]
end

template "#{node["nginx"]["dir"]}/sites-available/teamcity.rithis.com" do
  source "teamcity.rithis.com.erb"
  notifies :reload, "service[nginx]"
end

nginx_site "teamcity.rithis.com"
