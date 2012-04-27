# Author:: Matt Ray <matt@opscode.com>
# Cookbook Name:: fundamentals
# Recipe:: default
#
# Copyright 2012, Opscode, Inc
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

include_recipe "showoff"

directory "#{Chef::Config[:file_cache_path]}/chef-fundamentals"

#git clone fundamentals
git "#{Chef::Config[:file_cache_path]}/chef-fundamentals" do
  repository "git://github.com/opscode/chef-fundamentals.git"
  reference "master"
  action :sync
end

execute "bundle install --path vendor/bundle" do
  cwd "#{Chef::Config[:file_cache_path]}/chef-fundamentals"
  subscribes :run, resources(:git => "#{Chef::Config[:file_cache_path]}/chef-fundamentals")
end

runit_service "fundamentals" do
  options({
      :path => "#{Chef::Config[:file_cache_path]}/chef-fundamentals/slides"}.merge(params)
    )
end
