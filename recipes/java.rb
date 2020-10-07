#
# Cookbook Name:: desktop
# Recipe:: java
#
# Copyright 2020 Andrew Jones
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

package 'openjdk-8-jdk' do
  action :upgrade
end

#
# Install an actually-modern Java from adoptopenjdk via the java cookbook.
#
# (Boy, this is simpler than the old way, isn't it?)
#
adoptopenjdk_install '14'
