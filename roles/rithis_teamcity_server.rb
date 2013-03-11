name "rithis_teamcity_server"

run_list(
  "role[rithis_node]",
  "recipe[rithis_teamcity_server]"
)
