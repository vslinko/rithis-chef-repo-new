name "node-uptime"

run_list(
    "role[node]",
    "recipe[node-uptime]"
)
