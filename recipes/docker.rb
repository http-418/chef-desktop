#
# Cookbook Name:: desktop
# Recipe:: docker
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

#
# Debian jessie had to remove docker for golang compatibility.
# A version depending on newer golang is available in backports.
#
if node['platform'] == 'debian'
  include_recipe 'desktop::backports'
end

package 'docker.io'

docker_service = 'docker'

template '/etc/default/docker.io' do
  mode 0444
  source 'docker/docker.io-defaults.erb'
  notifies :restart, "service[#{docker_service}]", :immediately
end

service docker_service do
  action [:enable, :start]
end
