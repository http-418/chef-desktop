#
# Cookbook Name:: desktop
# Recipe:: default
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

# apt
include_recipe 'apt'

# Hardware.
include_recipe 'desktop::bluetooth'
include_recipe 'desktop::irqbalance'
include_recipe 'desktop::pc-speaker'
include_recipe 'desktop::pulseaudio'
include_recipe 'desktop::synaptics'
include_recipe 'desktop::graphics'

# Software.
include_recipe 'desktop::applications'
include_recipe 'desktop::ssh'

# Primary user configuration -- see attributes/user.rb!
include_recipe 'desktop::user'

