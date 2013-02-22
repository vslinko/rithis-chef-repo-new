name "chef-server"

run_list(
    "role[node]",
    "recipe[chef-server]"
)
