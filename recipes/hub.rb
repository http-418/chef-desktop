#
# Cookbook Name:: desktop
# Recipe:: hub
#
# Copyright 2016 Andrew Jones
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
# Installs the github 'hub' wrapper for git.
#
hub_version = '2.2.2'

hub_checksum =
  'da2d780f6bca22d35fdf71c8ba1d11cfd61078d5802ceece8d1a2c590e21548d'

hub_url =
  'https://github.com/github/hub/releases/download/v' +
  hub_version + '/hub-linux-amd64-' + hub_version + '.tgz'

ark 'github-hub' do
  action :put
  url hub_url
  path Chef::Config[:file_cache_path]
  checksum hub_checksum
end

# This is a directory inside the tarball, and we asked 'ark' to dump the
# tarball into the file_cache_path.
hub_path =
  Chef::Config[:file_cache_path] + '/github-hub'

execute 'hub-install' do
  command 'install -m 0555 -T ' +
    "#{hub_path}/bin/hub /usr/local/bin/hub"
  not_if "diff #{hub_path}/bin/hub /usr/local/bin/hub"
end

directory '/usr/local/share/man/man1' do
  mode 0755
  recursive true
end

execute 'hub-man-install' do
  command 'install -m 0444 -T ' +
    "#{hub_path}/share/man/man1/hub.1 /usr/local/share/man/man1/hub.1"
end

execute 'hub-completion-install' do
  command 'install -m 0444 -T ' +
    "#{hub_path}/etc/hub.bash_completion.sh /etc/bash_completion.d/hub"
end
  
