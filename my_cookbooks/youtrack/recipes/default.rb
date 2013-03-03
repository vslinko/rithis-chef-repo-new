include_recipe "bluepill"
include_recipe "java"
include_recipe "nginx"

port = 8112
jar_name = "youtrack-#{node["youtrack"]["version"]}.jar"
jar = "/opt/YouTrack/bin/#{jar_name}"

directory "/opt/YouTrack"
directory "/opt/YouTrack/bin"
directory "/opt/YouTrack/logs"

remote_file jar do
  backup false
  source "http://download.jetbrains.com/charisma/#{jar_name}"
  action :create_if_missing
end

template "/opt/YouTrack/bin/start.sh" do
  mode 0755
  source "start.sh.erb"
  variables(
    :jar => jar,
    :port => port
  )
end

template "#{node["bluepill"]["conf_dir"]}/youtrack.pill" do
  source "youtrack.pill.erb"
end

bluepill_service "youtrack" do
  action [:enable, :load, :start]
end

template "#{node["nginx"]["dir"]}/sites-available/youtrack.rithis.com" do
  source "youtrack.rithis.com.erb"
  variables(
    :port => port
  )
  notifies :reload, "service[nginx]"
end

nginx_site "youtrack.rithis.com"
