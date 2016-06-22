#
# Cookbook Name:: desktop
# Recipe:: google-chrome
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

apt_repository 'google-chrome-unstable' do
  uri 'http://dl.google.com/linux/deb/'
  arch 'amd64'
  components ['stable', 'main']
  keyserver 'keyserver.ubuntu.com'
  key 'A040830F7FAC5991'
end

if Gem::Version.new(node[:platform_version]) >= Gem::Version.new('16.04')
  log 'Forcing apt update to work around apt cookbook bugs on 16.04' do
    notifies :run, 'execute[apt-get update]', :immediately
  end
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
