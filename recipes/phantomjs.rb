#
# Cookbook Name:: desktop
# Recipe:: phantomjs
# Author:: Andrew Jones
#
# Compiles phantomjs from source because Linux binaries are not
# currently available.  (The project authors are obsessed with
# multiplatform centos/ubuntu static binaries, and that's a hard
# thing to accomplish in 2015.)
#

include_recipe 'apt'

package %w(
  build-essential g++ flex bison gperf ruby perl
  libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev
  libpng-dev libjpeg-dev python libx11-dev libxext-dev
) do
  action :install
end

phantom_build_path = "/usr/local/src/phantomjs"

directory phantom_build_path do
  user node[:desktop][:user][:name]
  group node[:desktop][:user][:group]
end

git phantom_build_path do
  repository 'https://github.com/ariya/phantomjs.git'
  user node[:desktop][:user][:name]
  group node[:desktop][:user][:group]
  # This is the 2.0.0 tag, not the 2.0 branch.
  revision '2.0.0'
end

execute 'phantomjs-build' do
  cwd phantom_build_path
  creates "#{phantom_build_path}/bin/phantomjs"
  user node[:desktop][:user][:name]
  command "#{phantom_build_path}/build.sh --confirm"
end

file '/usr/local/bin/phantomjs' do
  content lazy { IO.read("#{phantom_build_path}/bin/phantomjs") }
  mode 0555
end
