**This is for a training lab. Do not use in production.**

_This cookbook will allow internet accessible systems to be accessed
over SSH or VNC with a fairly simple password. Terminate instances
after the training is concluded._

Description
===========

Used in the `target` and `workstation` roles, this cookbook sets up
instances for students to use in Chef training hands on exercises.

Requirements
============

This cookbook only supports Ubuntu, and the default recipe will raise
an exception if another platform is used.

Recipes
=======

## default

Includes the other recipes. Also makes sure the byobu shell script is
removed.

## packages

Ensures the packages required for workstation use are installed,
including text editors, Gnome and VNC.

Enables multiverse, so students can install additional packages for
their use during the class.

Potential leftover Ruby cruft is removed, as well. We only want/need
to have Ruby installed for Chef, and we use the Chef full package.

## ssh

Enables password login via SSH for the Ubuntu user, and sets the
password according to the `node['workstation']['password']` attribute.

## editors

Ensure that some sane default configuration is set up using Vim as the
default text editor. Emacs is also installed (in the `packages`
recipe), and a number of goodies are installed (like ido-mode and
ruby-mode), and Emacs users will know what they want to use.

Sublime Text 2 is installed, but
*[Opscode does not provide a license](http://www.sublimetext.com/eula)*.
Sublime Text 2 is only usable for students who log into their
workstation instance with VNC. Users who like Sublime Text 2 will need
to install it on their own system and procure their own license.

## vnc

Sets up a VNC server so students who wish to have a GUI environment
for their workstation are able to do so. The password is the same as
the attribute `node['workstation']['password']`.

Attributes
==========

* `node['workstation']['password']` - set the password for the ubuntu
  user to login. You must share this password with the students, and
  in the classroom node, the web page will display it.

License and Author
==================

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
