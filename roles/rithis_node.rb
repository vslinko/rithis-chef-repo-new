name "rithis_node"

run_list(
  "recipe[ubuntu]",
  "recipe[apt]",
  "recipe[vslinko]"
)
