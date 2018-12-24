#
# Cookbook Name:: desktop
# Recipe:: java
#
# Copyright 2015 Andrew Jones
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

node.default[:java][:install_flavor] = 'oracle'
node.default[:java][:jdk_version] = '8'
node.default[:java][:oracle][:accept_oracle_download_terms] = true

#
# Install a packaged java to satisfy Debian deps.
#
# Apt will not detect the existence of oracle java, so debian packages
# that depend on java will attempt to pull in a java, and that is
# often gcj.
#
if debian_before(9.0) || ubuntu_before(16.10)
  include_recipe 'desktop::backports'
else
  include_recipe 'desktop::apt'
end

if node[:platform] == 'debian'
  package 'openjdk-8-jdk' do
    action :upgrade
  end
elsif node[:plaftorm] == 'ubuntu'
  # Do nothing.
end

#include_recipe 'java'
#
#java_alternatives 'oracle-java-alternatives' do
#  java_location '/usr/lib/jvm/java-8-oracle-amd64'
#  action :set
#end
