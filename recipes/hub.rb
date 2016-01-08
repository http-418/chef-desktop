#
# Cookbook Name:: desktop
# Recipe:: hub
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
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
  
