#
# Cookbook Name:: desktop
# Recipe:: wine
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
#
# WARNING: this recipe is not 100% idempotent.
# 

# 32 bit development libraries.
[
 'gcc-multilib',
 'g++-multilib',
 'libfreetype6-dev:i386',
 'libglu1-mesa-dev:i386',
 'libxcomposite-dev:i386',
 'libxrandr-dev:i386',
 'libxi-dev:i386',
 'libxcursor-dev:i386',
 'libglu1-mesa-dev:i386',
 'libxcomposite-dev:i386',
 'libdbus-1-dev:i386',
 'libtiff5-dev:i386',
 'libncurses5-dev:i386',
 'libosmesa6-dev:i386',
 'libcups2-dev:i386',
 'libfontconfig1-dev:i386',
 'xserver-xorg-dev:i386',
].each do |package_name|
  package package_name
end

# known-working compiler
package 'gcc-4.9'
package 'g++-4.9'

admin_user = node['desktop']['user']['name']
admin_group = node['desktop']['user']['group']
wine_path = '/opt/wine'

directory '/usr/local/src/wine' do
  user admin_user
  group admin_group
  mode 0755
end

git '/usr/local/src/wine' do
  user admin_user
  group admin_group
  repository 'git://source.winehq.org/git/wine.git'
  revision 'wine-1.7.48'
  action :sync
  notifies :run, 'execute[wine-clean]'
end

directory wine_path do
  user admin_user
  group admin_group
end

build_environment =
{
 'CC' => 'gcc-4.9',
 'CXX' => 'g++-4.9',
 'LDFLAGS' => "-Wl,-rpath=#{wine_path}/lib,-L#{wine_path}/lib"
}

job_count = node['cpu']['total'].to_i

execute 'wine-clean' do
  cwd '/usr/local/src/wine'
  user admin_user
  environment build_environment
  command "make clean"
  # Don't run unless the git repo has changed.
  action :nothing
end

execute 'wine-configure' do
  cwd '/usr/local/src/wine'
  user admin_user
  environment build_environment
  command "./configure --prefix #{wine_path}"
end

execute 'wine-build' do
  cwd '/usr/local/src/wine'
  user admin_user
  environment build_environment
  command "make -j #{job_count}"
end

execute 'wine-install' do
  cwd '/usr/local/src/wine'
  user admin_user
  environment build_environment
  command 'make install'
end
