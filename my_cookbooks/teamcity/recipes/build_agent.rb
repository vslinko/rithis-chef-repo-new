include_recipe "teamcity::common"

if node["teamcity"]["build_agent"]["server_url"].nil?
  server_node = search(:node, "recipes:teamcity\\:\\:server").first
  unless server_node.nil?
    node.default["teamcity"]["build_agent"]["server_url"] = server_node["ipaddress"]
  end
end

unless node["teamcity"]["build_agent"]["server_url"].nil?
  build_agent_properties = "/opt/TeamCity/buildAgent/conf/buildAgent.properties"
  server_url = node["teamcity"]["build_agent"]["server_url"]
  own_address = node["ipaddress"]
  authorization_token = nil

  if server_url == own_address
    server_url = own_address = "127.0.0.1"
  end

  if File.exists?(build_agent_properties)
    lines = File.readlines(build_agent_properties).grep(/^authorizationToken=/)
    unless lines.empty?
        match = /authorizationToken=([0-9a-f]+)/.match(lines.first)
        authorization_token = match[1] if match
    end
  end

  template build_agent_properties do
    source "buildAgent.properties.erb"
    variables(
      :server_url => server_url,
      :name => node["teamcity"]["build_agent"]["name"],
      :own_address => own_address,
      :authorization_token => authorization_token
    )
    notifies :restart, "bluepill_service[teamcity-build-agent]"
  end

  template "#{node["bluepill"]["conf_dir"]}/teamcity-build-agent.pill" do
    source "teamcity-build-agent.pill.erb"
  end

  bluepill_service "teamcity-build-agent" do
    action [:enable, :load, :start]
  end
end
