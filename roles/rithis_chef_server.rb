name "rithis_chef_server"

run_list(
  "role[rithis_node]",
  "recipe[chef-server]"
)
