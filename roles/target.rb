name "target"
description "Used for tagging which boxes are targets"
run_list("recipe[knife-workstation::ssh]")
