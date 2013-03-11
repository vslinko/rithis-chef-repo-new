include_recipe "nginx"
include_recipe "youtrack"

template "#{node["nginx"]["dir"]}/sites-available/youtrack.rithis.com" do
  source "youtrack.rithis.com.erb"
  variables :port => node["youtrack"]["port"]
  notifies :reload, "service[nginx]"
end

nginx_site "youtrack.rithis.com"
