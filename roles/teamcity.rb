name "teamcity"

run_list(
  "role[default]",
  "recipe[node-build-agent]",
  "recipe[teamcity]"
)
