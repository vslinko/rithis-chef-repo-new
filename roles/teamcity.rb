name "teamcity"

run_list(
  "role[default]",
  "recipe[teamcity::server]",
  "recipe[node-build-agent]"
)

override_attributes(
  "teamcity" => {
    "build_agent" => {
      "name" => "Default Agent"
    }
  }
)
