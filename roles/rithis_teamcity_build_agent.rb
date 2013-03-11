name "rithis_teamcity_build_agent"

run_list(
  "role[rithis_node]",
  "recipe[rithis_teamcity_build_agent]"
)
