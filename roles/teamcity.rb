name "teamcity"

run_list(
    "role[node]",
    "recipe[node-build-agent]",
    "recipe[teamcity]"
)
