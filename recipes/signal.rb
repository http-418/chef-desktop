#
# Cookbook Name:: desktop
# Recipe:: signal
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

apt_repository 'updates.signal.org' do
  uri 'https://updates.signal.org/desktop/apt'
  arch 'amd64'
  key 'https://updates.signal.org/desktop/apt/keys.asc'
  distribution 'xenial'
  components ['main']
end

package 'signal-desktop-beta' do
  action :upgrade
end

# Enable unprivileged ns cloning so we can remove signal suid bits
sysctl 'kernel.unprivileged_userns_clone' do
  value 1
end

# Remove suid bits
execute 'chmod -s /opt/Signal*/chrome-sandbox' do
  user 'root'
  action :run
end
