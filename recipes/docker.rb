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

# Debian jessie had to remove docker for golang compatibility.
# A version depending on newer golang is available in backports.
if node['platform'] == 'debian'
  include_recipe 'desktop::backports'
end

package 'docker.io'

docker_service = if( node['platform'] == 'ubuntu')
                   'docker.io'
                 else
                   'docker'
                 end

template '/etc/default/docker.io' do
  mode 0444
  source 'docker/docker.io-defaults.erb'
  notifies :restart, "service[#{docker_service}]", :immediately
end

service docker_service do
  action [:enable, :start]
end
