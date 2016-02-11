#
# Cookbook Name:: desktop
# Recipe:: irqbalance
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'

package 'irqbalance'

service 'irqbalance' do
  action [:enable, :start]
end
