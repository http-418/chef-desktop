#
# Cookbook Name:: desktop
# Recipe:: nodejs
# Author:: Andrew Jones
#

node.default['nodejs']['install_method'] = 'package'
include_recipe 'nodejs'
include_recipe 'nodejs::npm'

nodejs_npm 'source-map-support'
