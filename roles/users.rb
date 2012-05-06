name "users"
description "Put users on training boxes"
run_list(
  "recipe[users::sysadmins]",
  "recipe[sudo]"
  )

default_attributes(
  "authorization" => {
    "sudo" => {
      "groups" => ["admin", "wheel", "sysadmin"],
      "users" => ["ubuntu"],
      "passwordless" => true
    }
  }
  )
