#
# Cookbook Name:: desktop
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# apt
include_recipe 'desktop::apt'

# Hardware.
include_recipe 'desktop::pc-speaker'
include_recipe 'desktop::bluetooth'
include_recipe 'desktop::nvidia'

# Software.
include_recipe 'desktop::applications'

# Primary user configuration -- see attributes/user.rb!
include_recipe 'desktop::user'

