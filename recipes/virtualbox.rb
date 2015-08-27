#
# Cookbook Name:: desktop
# Recipe:: virtualbox
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

package 'virtualbox-4.3' do
  action :remove
end

package [ 
         'build-essential',
         'dkms',
         'virtualbox-5.0' 
        ] do
    action :install
end

