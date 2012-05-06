Overview
========

Every Chef installation needs a Chef Repository. This one was created for installing the Opscode Chef Fundamentals training on a node with Showoff already configured. This repo fires up an Ubuntu 11.10 instance on EC2. You will need to have a "showoff" security group with port 9090 open.

Spiceweasel
===========

This repo has an `infrastructure.yml` file for use with Spiceweasel (http://bit.ly/spcwsl). To get the knife commands for deploying this infrastructure, use the command

    spiceweasel infrastructure.yml

and it will output the knife commands needed to build and deploy this basic infrastructure. The `knife ec2 server create` and `knife rackspace server create` commands at the end will deploy the exact configuration on 2 different cloud providers. You can use the `--parallel` flag with Spiceweasel if you have `parallel` installed.


    spiceweasel --parallel infrastructure.yml


Workstations & Target Machines
==============================

Since this is for Chef Fundamentals, you can use this training private/public key combination to create workstations to hand out to the class. Chef will be installed on them already (adding an empty repo might be worthwhile). You can use the private key in the GitHub repo to connect to the machines. To "fix" the machines to be used for bootstrapping and manipulating (the "target" machines), remove Chef after the nodes have been created.

    knife ssh "role:target" "sudo rm -vrf /etc/chef /var/chef" -x ubuntu -i training_rsa -a cloud.public_hostname
    knife ssh "role:target" "sudo gem uninstall chef ohai -x" -x ubuntu -i training_rsa -a cloud.public_hostname

Repository Directories
======================

This repository contains several directories, and each directory contains a README file that describes what it is for in greater detail, and how to use it for managing your systems with Chef.

* `cookbooks/` - Cookbooks you download or create. Populate it by running the commands output by `spiceweasel infrastructure.yml`.
* `data_bags/` - Store data bags and items in .json in the repository. There is a `users` directory and an `mray.json` example for use with the `users` cookbook.
* `roles/` - Store roles in .rb or .json in the repository. There is a `base.rb` base role that has the run list and settings for using the `sudo` cookbook.

Configuration
=============

You can use the `.chef/knife.rb` provided with the repo, as long as you provide the proper environment variables for repository-specific configuration. If you're using the Opscode Platform, you can download one for your organization from the management console. If you're using the Open Source Chef Server, you can generate a new one with `knife configure`. For more information about configuring Knife, see the Knife documentation.

http://help.opscode.com/faqs/chefbasics/knife

