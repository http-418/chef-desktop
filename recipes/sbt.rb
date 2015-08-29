#
# Cookbook Name:: desktop
# Recipe:: sbt
# Author:: Andrew Jones
#

include_recipe 'apt'
include_recipe 'desktop::java'

package 'apt-transport-https'

apt_repository 'sbt' do
  uri 'https://dl.bintray.com/sbt/debian'
  components ['/']
  key '642AC823'
  keyserver 'keyserver.ubuntu.com'
  action :add
  notifies :run, 'execute[apt-get update]', :immediately
end

package 'sbt'
