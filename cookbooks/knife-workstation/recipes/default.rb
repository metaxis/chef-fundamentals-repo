#
# Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: knife-workstation
# Recipe:: default
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

Chef::Config[:verbose_logging] = false
unless platform?("ubuntu")
  Chef::Log.fatal("#{cookbook_name}::#{recipe_name} is not supported on platform #{node['platform']}")
  raise "Unsupported platform!"
end

file("/etc/profile.d/Z97-byobu.sh") { action :delete }

include_recipe "knife-workstation::packages"
include_recipe "knife-workstation::ssh"
include_recipe "knife-workstation::editors"
include_recipe "knife-workstation::vnc"

log "The workstation is now configured:"
log "Login: ubuntu Password: #{node['workstation']['password']}"
