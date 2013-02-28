name "chef-server"

run_list(
    "role[default]",
    "recipe[chef-server]"
)
