require "net/https"
require "json"
require "uri"

include_recipe "chef-client::cron"
include_recipe "mongodb::10gen_repo"
include_recipe "nginx"
include_recipe "nodejs"
include_recipe "runit"

def request(url)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  JSON.parse response.body
end

projects = []
port = 3000
data_bag("staging_projects").each do |name|
  project = data_bag_item("staging_projects", name)

  user = project["github"]["user"]
  repo = project["github"]["repo"]

  branches_url = "https://api.github.com/repos/#{user}/#{repo}/branches"

  begin
    branches = request(branches_url)
  rescue => e
    Chef::Log.warn "Unable to load #{branches_url}, reason #{e}"
  else
    branches.each do |branch|
      branch = branch["name"]
      package_url = "https://raw.github.com/#{user}/#{repo}/#{branch}/package.json"

      begin
        package = request(package_url)
      rescue => e
        Chef::Log.warn "Unable to load #{package_url}, reason #{e}"
      else
        reversed_name = branch.split("/").reverse.push(name)

        projects.push(
          "name" => reversed_name.reverse.join("."),
          "subdomain" => reversed_name.join("."),
          "repository" => "git://github.com/#{user}/#{repo}.git",
          "reference" => branch,
          "port" => port,
          "script" => package["scripts"]["start"]
        )

        port += 1
      end
    end
  end
end

projects.each do |project|
  staging_project project["name"] do
    repository project["repository"]
    reference project["reference"]
    port project["port"]
    script project["script"]
  end
end

template "#{node["nginx"]["dir"]}/sites-available/staging.rithis.com" do
  source "staging.rithis.com.erb"
  variables(
    :projects => projects
  )
  notifies :reload, "service[nginx]"
end

nginx_site "staging.rithis.com"
