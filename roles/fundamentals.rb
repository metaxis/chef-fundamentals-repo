name "fundamentals"
description "Default run_list for Fundamentals Showoff machine"
run_list(
  "recipe[ruby::1.9.1]",
  "recipe[build-essential]",
  "recipe[showoff]",
  "recipe[fundamentals]"
  )
