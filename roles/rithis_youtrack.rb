name "rithis_youtrack"

run_list(
  "role[rithis_node]",
  "recipe[rithis_youtrack]"
)
