#
# Cookbook Name:: desktop
# Recipe:: heroku
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'

apt_repository 'heroku' do
  uri 'http://toolbelt.heroku.com/ubuntu'
  components ['/']
  key 'https://toolbelt.heroku.com/apt/release.key'
end

package 'heroku-toolbelt'
