Overview
========

Every Chef installation needs a Chef Repository. This one was created for installing the Opscode Chef Fundamentals training on a node with Showoff already configured. This repo fires up an Ubuntu 11.10 instance on EC2.

Spiceweasel
===========

This repo has an `infrastructure.yml` file for use with Spiceweasel (http://bit.ly/spcwsl). To get the knife commands for deploying this infrastructure, use the command

`spiceweasel infrastructure.yml`

and it will output the knife commands needed to build and deploy this basic infrastructure. The `knife ec2 server create` and `knife rackspace server create` commands at the end will deploy the exact configuration on 2 different cloud providers.

Repository Directories
======================

This repository contains several directories, and each directory contains a README file that describes what it is for in greater detail, and how to use it for managing your systems with Chef.

* `cookbooks/` - Cookbooks you download or create. Populate it by running the commands output by `spiceweasel infrastructure.yml`.
* `data_bags/` - Store data bags and items in .json in the repository. There is a `users` directory and an `mray.json` example for use with the `users` cookbook.
* `roles/` - Store roles in .rb or .json in the repository. There is a `base.rb` base role that has the run list and settings for using the `sudo` cookbook.

Configuration
=============

You will need to add the configuration directory `.chef` and your `.chef/knife.rb` with repository-specific configuration. If you're using the Opscode Platform, you can download one for your organization from the management console. If you're using the Open Source Chef Server, you can generate a new one with `knife configure`. For more information about configuring Knife, see the Knife documentation.

http://help.opscode.com/faqs/chefbasics/knife

