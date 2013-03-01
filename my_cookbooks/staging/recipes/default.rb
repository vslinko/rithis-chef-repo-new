include_recipe "nodejs"
include_recipe "mongodb::10gen_repo"
include_recipe "runit"
include_recipe "nginx"
include_recipe "chef-client::cron"

execute "npm install -g underscore-cli"

projects = []
port = 3000
data_bag("staging_projects").each do |name|
    project = data_bag_item("staging_projects", name)

    project["references"].each do |reference|
        reversed_name = reference.split("/").reverse.push(name)
        projects.push(
            "name" => reversed_name.reverse.join("."),
            "reversed_name" => reversed_name.join("."),
            "repository" => project["repository"],
            "reference" => reference,
            "port" => port
        )
        port += 1
    end
end

projects.each do |project|
    staging_project project["name"] do
        repository project["repository"]
        reference project["reference"]
        port project["port"]
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
