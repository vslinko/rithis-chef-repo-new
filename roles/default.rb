name "default"

run_list(
    "recipe[ubuntu]",
    "recipe[apt]",
    "recipe[sudo]",
    "recipe[zsh]",
    "recipe[users::sysadmins]",
    "recipe[vyacheslav-dotfiles]"
)

override_attributes(
    "authorization" => {
        "sudo" => {
            "passwordless" => true,
            "sudoers_defaults" => ["env_reset"]
        }
    }
)
