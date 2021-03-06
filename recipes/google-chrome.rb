#
# Cookbook Name:: desktop
# Recipe:: google-chrome
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

include_recipe 'apt'

apt_repository 'google-chrome-unstable' do
  uri 'http://dl.google.com/linux/deb/'
  arch 'amd64'
  distribution ''
  components ['stable', 'main']
  keyserver 'keyserver.ubuntu.com'
  key '78BD65473CB3BD13'
end

log 'Forcing apt update to work around apt cookbook bugs on buster/xenial' do
  notifies :run, 'execute[apt-get update]', :immediately
end

package [ 'google-chrome-unstable', 'google-chrome-beta' ] do
  action :upgrade
  timeout 3600
end

# Delete one of the sources lists to avoid spurious warnings.
file '/etc/apt/sources.list.d/google-chrome-beta.list' do
  action :delete
  notifies :run, 'execute[apt-get update]', :immediately
end

# Enable unprivileged ns cloning so we can remove chrome suid bits
sysctl 'kernel.unprivileged_userns_clone' do
  value 1
end

# Remove suid bits
execute 'chmod -s /opt/google/*/chrome-sandbox' do
  user 'root'
  action :run
end
