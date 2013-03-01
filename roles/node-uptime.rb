name "node-uptime"

run_list(
  "role[default]",
  "recipe[node-uptime]"
)
