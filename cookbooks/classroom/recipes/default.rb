#
# Cookbook:: classroom
# Recipe:: default
#
# Author:: Joshua Timberman <joshua@opscode.com>
# Copyright:: Copyright (c) 2012, Opscode, Inc. <legal@opscode.com>
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if Chef::Config[:solo]
  raise "This recipe requires a Chef Server for search at this time."
end

workstations = search(:node, "ohai_time:* AND role:workstation")
targets = search(:node, "ohai_time:* AND role:target")

package "apache2"

service "apache2" do
  action [:start,:enable]
end

template "/var/www/index.html" do
  source "index.html.erb"
  mode 00644
  backup 0
  variables(
    :workstations => workstations,
    :targets => targets
  )
end
