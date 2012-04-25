name "fundamentals"
description "Default run_list for Fundamentals Showoff machine"
run_list(
  "recipe[rubygems::install]",
  "recipe[showoff]",
  "recipe[fundamentals]"
  )
