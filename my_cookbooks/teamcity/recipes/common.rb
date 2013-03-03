include_recipe "java"
include_recipe "runit"

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
