#
# Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: knife-workstation
# Recipe:: packages
#
# Copyright 2012, Opscode, Inc <legal@opscode.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

pkgs = %w{
whois
ack-grep
git
subversion
mercurial
bzr
unzip
vim-nox
emacs23-nox
emacs-goodies-el
gnome-core
vnc4server
gedit
x11vnc
}

rmpkgs = %w{libruby1.8 ruby1.8 libruby ruby ec2-ami-tools}

file "/etc/apt/sources.list.d/multiverse.list" do
  content <<-EOH
deb http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise multiverse
deb-src http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise multiverse
deb http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates multiverse
deb-src http://us-east-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates multiverse
deb http://security.ubuntu.com/ubuntu precise-security multiverse
deb-src http://security.ubuntu.com/ubuntu precise-security multiverse
EOH
end

execute "apt-get update" do
  ignore_failure true
end

pkgs.each {|p| package p}

rmpkgs.each do |p|
  package p do
    action :purge
  end
end
