#
# Cookbook Name:: desktop
# Recipe:: google-chrome
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

apt_repository 'google-chrome-unstable' do
  uri 'http://dl.google.com/linux/chrome/deb/'
  components ['stable', 'main']
  keyserver 'keyserver.ubuntu.com'
  key 'A040830F7FAC5991'
end

package [ 'google-chrome-unstable', 'google-chrome-beta' ] do
  action :upgrade
end

# Delete one of the sources lists to avoid spurious warnings.
file '/etc/apt/sources.list.d/google-chrome-beta.list' do
  action :delete
  notifies :run, 'execute[apt-get update]', :immediately
end
