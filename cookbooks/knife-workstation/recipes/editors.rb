#
# Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: knife-workstation
# Recipe:: editors
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

file "/etc/vim/vimrc.local" do
  content <<-EOH
set number
set laststatus=2
set ruler
set backupdir=~/.vimswaps,/tmp
set directory=~/.vimswaps,/tmp
set backspace=indent,eol,start
set autoindent
set smartindent
autocmd FileType ruby set tabstop=2
autocmd FileType ruby set softtabstop=2
autocmd FileType ruby set expandtab
EOH
  mode 00644
end

file "/etc/motd.tail" do
  content <<-EOH
************************************************************************
Welcome to Opscode Chef Fundamentals.

This system is the *workstation* system provided for your use to
complete the course's hands on exercises. The following software is
installed:

* Chef
* Git
* Vim
* Emacs
* Sublime Text 2

Some handy defaults for editing Ruby in Vim have been configured in
/etc/vim/vimrc.local. You're welcome to copy your favorite editor
configuration, too.

Don't forget to export the EDITOR shell variable. It is vim by default,
but you can use nano or emacs.

export EDITOR=emacs
export EDITOR=nano
export EDITOR=\"sublime_text -w\"

In ~/.bashrc.
************************************************************************

EOH
  mode 00644
end

file "/etc/profile.d/knife_editor.sh" do
  content "export EDITOR=/usr/bin/vim"
  mode 00644
end

remote_file "/tmp/SublimeText2.tar.bz2" do
  arch = node['kernel']['machine'] =~ /x86_64/ ? "%20x64" : ""
  source "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202%20Build%202181#{arch}.tar.bz2"
  not_if { ::File.symlink?("/opt/SublimeText2") }
end

execute "install sublimetext2" do
  command <<-EOH
tar -jxf /tmp/SublimeText2.tar.bz2 -C /opt
EOH
end

link "/opt/SublimeText2" do
  to "/opt/Sublime\ Text\ 2"
end

file "/etc/profile.d/sublime_path.sh" do
  content "export PATH=$PATH:/opt/SublimeText2\n"
  mode 00644
end
