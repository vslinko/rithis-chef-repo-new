include_recipe "java"
include_recipe "runit"
include_recipe "nginx"

cwd = "/opt"
archive_name = "TeamCity-#{node["teamcity"]["version"]}.tar.gz"
archive = "#{cwd}/#{archive_name}"

remote_file archive do
    backup false
    source "http://download.jetbrains.com/teamcity/#{archive_name}"
    action :create_if_missing
    notifies :run, "execute[unarchive]"
end

execute "unarchive" do
    command "tar xf #{archive}"
    cwd cwd
    action :nothing
end

runit_service "teamcity-server" do
    log false
end

runit_service "teamcity-build-agent" do
    log false
end

template "#{node["nginx"]["dir"]}/sites-available/teamcity.rithis.com" do
  source "teamcity.rithis.com.erb"
  notifies :reload, "service[nginx]"
end

nginx_site "teamcity.rithis.com"
