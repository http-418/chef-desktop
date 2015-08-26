#
# Cookbook Name:: desktop
# Recipe:: docker
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#
# This is the catch-all recipe for configuring desktop applications.
# Complex installs get their own recipes (e.g. kde, wine)
#

package 'docker.io'

template '/etc/default/docker.io' do
  mode 0444
  source 'docker/docker.io-defaults.erb'
  notifies :restart, 'service[docker.io]', :immediately
end

service 'docker.io' do
  action [:enable, :start]
end
