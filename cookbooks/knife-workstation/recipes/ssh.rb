#
# Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: knife-workstation
# Recipe:: ssh
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

package "whois"

execute "Update Ubuntu User Password" do
  command "usermod -p \"$(echo #{node['workstation']['password']} | mkpasswd -m sha-512 -s)\" ubuntu"
end

service "ssh" do
  supports :reload => true
  action [:enable,:start]
end

ruby_block "Enable password auth in SSH" do
  block do
    sshd = Chef::Util::FileEdit.new("/etc/ssh/sshd_config")
    sshd.search_file_replace_line(/^PasswordAuthentication no$/, "PasswordAuthentication yes")
    sshd.write_file
  end
  action :create
  not_if "grep -qx '^PasswordAuthentication yes$' /etc/ssh/sshd_config"
  notifies :reload, "service[ssh]", :immediately
end
