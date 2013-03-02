include_recipe "java"
include_recipe "nginx"
include_recipe "runit"

port = 3000
jar_name = "youtrack-#{node["youtrack"]["version"]}.jar"
jar = "/opt/#{jar_name}"

remote_file jar do
  backup false
  source "http://download.jetbrains.com/charisma/#{jar_name}"
  action :create_if_missing
end

runit_service "youtrack" do
  options(
    :jar => jar,
    :port => port
  )
  default_logger true
end

template "#{node["nginx"]["dir"]}/sites-available/youtrack.rithis.com" do
  source "youtrack.rithis.com.erb"
  variables(
    :port => port
  )
  notifies :reload, "service[nginx]"
end

nginx_site "youtrack.rithis.com"
