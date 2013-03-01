name "staging"

run_list(
  "role[default]",
  "recipe[staging]"
)


override_attributes(
  "chef_client" => {
    "cron" => {
      "minute" => "*/10",
      "hour" => "*",
      "use_cron_d" => true
    }
  }
)
