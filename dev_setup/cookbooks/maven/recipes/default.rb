#
# Cookbook Name:: maven
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

include_recipe "java"

case node.platform
when "redhat", "centos", "fedora"
  include_recipe "jpackage"
end

remote_file  File.join("", "tmp", "apache-maven-#{node[:maven][:version]}.tar.gz") do
  owner node[:deployment][:user]
  source node[:maven][:source]
  not_if { ::File.exists?(File.join("", "tmp", "apache-maven-#{node[:maven][:version]}.tar.gz")) }
  checksum 'd35a876034c08cb7e20ea2fbcf168bcad4dff5801abad82d48055517513faa2f'
end

directory node[:maven][:base] do
  owner node[:deployment][:user]
  group node[:deployment][:group]
  mode "0755"
  recursive true
  action :create
end

bash "Install Maven #{node[:maven][:path]}" do
  cwd node[:maven][:base]
  user node[:deployment][:user]
  tarball = File.join("", "tmp", "apache-maven-#{node[:maven][:version]}.tar.gz")
  code <<-EOH
      tar xzf #{tarball}
  EOH
  not_if do
    ::File.exists?(File.join(node[:maven][:path], "bin", "mvn"))
  end
end
