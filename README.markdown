Chef Repository for managing training lab instances for students
taking a Chef Fundamentals or Chef Workshop training course.

**Read this README in its entirety before setting up your lab.**

Assumptions
===========

This repository is intended for use by Opscode Chef instructors. If
you are using it, we assume you know what you're doing.

This repository assumes that you have a *sane* Ruby/RubyGems
installation. We use rbenv or rvm and Ruby 1.9. You will need bundler
installed. You also need to have an Opscode Hosted Chef account and
organization created that will manage the instances for initial setup.

Instances can be launched in Amazon EC2 or Rackspace Cloud. An account
should be set up ahead of time.

Your cloud account's default security group should have the following
ports open:

* 22 (SSH)
* 80, 81, 82 (HTTP)
* 5901-6001 (VNC)

The target instances are Ubuntu 12.04 for both Amazon EC2 and
Rackspace Cloud. Our training materials depend on assumptions from
Ubuntu specifically.

Shell Environment
=================

In order to make this repository modular for different people as
trainers, specific settings are abstracted in the knife.rb config
file. The following environment variables must be exported in your
shell with the proper values beforehand.

* `ORGNAME` - the organization to use on Opscode Hosted Chef
* `OPSCODE_USER` - if your Opscode account username is different than
  your local user, set this
* `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` - normal AWS
  credentials
* `AWS_SSH_KEY` - the name of the SSH key pair to use, must already
  exist in your AWS account; add the private key to your SSH agent
* `RACKSPACE_USERNAME` and `RACKSPACE_API_KEY` - normal Rackspace
  Cloud credentials

E.g.,

    export ORGNAME="myorg"
    export OPSCODE_USER="jtimberman"
    export AWS_ACCESS_KEY_ID="your aws access key id"
    export AWS_SECRET_ACCESS_KEY="your aws secret access key"
    export AWS_SSH_KEY="jtimberman"
    export RACKSPACE_USERNAME="jtimberman-rackspace"
    export RACKSPACE_API_KEY="your rackspace API key"

Installation
============

Install the appropriate RubyGems required using bundler.

    bundle install

Gems that install programs require `bundle exec` to run (notably:
spiceweasel, knife).

Spiceweasel
===========

This repo has an `lab.yml` file for use with Spiceweasel
(http://bit.ly/spcwsl). Run spiceweasel to display the knife commands
required to deploy the infrastructure.

    bundle exec spiceweasel lab.yml

Cookbooks and Roles
===================

There are three roles and two cookbooks.

## Roles

* `classrom`: the node that simply displays a list of all the IPs of the
  lab instances for workstations and targets.
* `target`: nodes that will be managed by students in the class.
* `workstation`: nodes that are provided for students to use as a
  development and knife workstation

## Cookbooks

* `classroom` - Searches for all the workstation instances and target
  instances to make a list of IPs available on a web page that
  students can use. The node with this role is not used by the
  students, and is for the instructor.
* `knife-workstation` - Provides configuration for a "workstation"
  system that students can access via SSH or VNC (display 1). The
  recipe ensures that programmer style text editors are available,
  sets the ubuntu user password to "opscodechef", and enables VNC. The
  `ssh` recipe in this cookbook is used by the `target` role to ensure
  the ubuntu user password is set.

Knife Config and Bootstrap Template
===================================

`.chef/knife.rb` is not hardcoded with any values, and uses shell
environment variables to set user-specifics. See *Shell Environment*
above for variables that must be exported to the shell prior.

`.chef/bootstrap/student.erb` is a custom bootstrap template that
will:

* Ensure that the GPG keys for the Ubuntu repository are added (may
  not exist on some AMIs in EC2). **This is hardcoded to a specific key.**
* Install the [chef full stack client package](http://opscode.com/chef/install).
* Connect the system via chef-client to the configured Opscode Hosted
  Chef organization and configure it based on its role.
* Clean up after itself, removing /etc/chef, /var/chef and uninstall
  the chef package.

To use Opscode Private Chef, change the `chef_server_url`.

The bootstrap and Chef is intended to run only once on `target` and
`workstation` nodes, because they only run Chef to make their initial
configuration, and have node objects available for the `classroom`
node. Chef is not cleaned up on the `classroom` node because if an
instance needs to be replaced, rerunning Chef will update the IP list.

Workstations & Targets
======================

The AMI used by the `workstation` role for EC2 in `lab.yml` is
currently private. It simply has the "workstation" packages
preinstalled to save time launching instances. See
`workstation-ami.sh` for the commands to create a new AMI.

Launch a workstation for each student registered for your class.
Likewise, launch a target machine for each student. Once all these
instances are complete, launch the classroom system. Set the number of
instances to launch in lab.yml and Spiceweasel will print out all the
commands you need.

    knife ec2 server create -x ubuntu -I ami-f4fc5e9d -r 'role[workstation]'
    knife ec2 server create -x ubuntu -I ami-a29943cb -r 'role[target]'
    knife ec2 server create -x ubuntu -I ami-a29943cb -r 'role[classroom]'

Knife Plugin
============

Instead of launching the classroom system, you can also use the
included knife plugin, `knife lab` to output the instances for
students to use. For example:

    % knife lab
    https://opscode-chef-training.s3.amazonaws.com/ChefWorkshop-CheatSheet.pdf
    
    # Workstations (SSH or VNC display :1)
    184.72.153.99 opstrain1 # workstation
    
    # Target nodes (SSH)
    107.20.125.24 opstrain1 # target node

The CheatSheet PDF link is included for convenience.

To do:
======

* Use minitest-handler to perform integration testing of [all the things!](http://i.qkme.me/4tig.jpg)
* Clean up the older `chef-fundamentals` cruft.
* Release the "workstation" AMI; this requires ensuring it is cleaned
  up and fit for consumption by the masses.

License and Author
==================

- Author:: Matt Ray (<matt@opscode.com>)
- Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright (c) 2012, Opscode, Inc (<legal@opscode.com>)

Licensed under the Apache License, Version 2.0 (the "License"); you
may not use this file except in compliance with the License. You may
obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied. See the License for the specific language governing
permissions and limitations under the License.
