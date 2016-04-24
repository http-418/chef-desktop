#
# Cookbook Name:: desktop
# Recipe:: spotify
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'
include_recipe 'desktop::libgcrypt11'

apt_repository 'spotify' do
  uri 'http://repository.spotify.com'
  components ['stable', 'non-free']
  keyserver 'keyserver.ubuntu.com'
  key 'D2C19886'
end

package 'spotify-client'
