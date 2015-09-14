#
# Cookbook Name:: desktop
# Recipe:: wine
#
# Copyright 2015, Andrew Jones
#
# All rights reserved - Do Not Redistribute
# 

# 32 bit development libraries and their amd64 counterparts.
package_names = [
 'gcc-multilib',
 'g++-multilib',
 'libfreetype6-dev',
 'libfreetype6-dev:i386',
 'libglu1-mesa-dev',
 'libglu1-mesa-dev:i386',
 'libxcomposite-dev',
 'libxcomposite-dev:i386',
 'libxrandr-dev',
 'libxrandr-dev:i386',
 'libxi-dev',
 'libxi-dev:i386',
 'libxcursor-dev',
 'libxcursor-dev:i386',
 'libglu1-mesa-dev',
 'libglu1-mesa-dev:i386',
 'libxcomposite-dev',
 'libxcomposite-dev:i386',
 'libdbus-1-dev',
 'libdbus-1-dev:i386',
 'libtiff5-dev',
 'libtiff5-dev:i386',
 'libncurses5-dev',
 'libncurses5-dev:i386',
 'libosmesa6-dev',
 'libosmesa6-dev:i386',
 'libcups2-dev',
 'libcups2-dev:i386',
 'libfontconfig1-dev',
 'libfontconfig1-dev:i386',
 'xserver-xorg-dev',
 'xserver-xorg-dev:i386',
]

# amd64, all in one batch
package package_names.reject{ |p| p.include?(":i386") } do
  action :install
end

# now that the amd64 versions are pre-installed, tackle i386
package package_names.select{ |p| p.include?(":i386") } do
  action :install
end

# known-working compiler
gcc_version = node[:desktop][:wine][:gcc_version]
package "gcc-#{gcc_version}", "g++-#{gcc_version}}"

admin_user = node['desktop']['user']['name']
admin_group = node['desktop']['user']['group']
wine_path = node[:desktop][:wine][:wine_path]

directory '/usr/local/src/wine' do
  user admin_user
  group admin_group
  mode 0755
end

proto = if Chef::Config[:http_proxy]
          'https'
        else
          'git'
        end

git '/usr/local/src/wine' do
  user admin_user
  group admin_group
  repository "#{proto}://source.winehq.org/git/wine.git"
  #
  # You must change the gecko version + checksum to match the wine version.
  # These are hardcoded into wine!
  #
  # http://wiki.winehq.org/Gecko
  #
  revision 'wine-1.7.50'
  action :sync
  notifies :run, 'execute[wine-clean]'
  notifies :run, 'execute[wine-configure]'
end

directory wine_path do
  user admin_user
  group admin_group
end

build_environment =
{
 'CC' => "gcc-#{gcc_version}",
 'CXX' => "g++-#{gcc_version}",
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
  action :nothing
  notifies :run, 'execute[wine-build]'
end

execute 'wine-build' do
  cwd '/usr/local/src/wine'
  user admin_user
  environment build_environment
  command "make -j #{job_count}"
  action :nothing
  notifies :run, 'execute[wine-install]'
end

execute 'wine-install' do
  cwd '/usr/local/src/wine'
  user admin_user
  environment build_environment
  command 'make install'
  action :nothing
end

directory '/usr/share/wine' do
  mode 0755
end

directory '/usr/share/wine/gecko' do
  mode 0755
end

#
# This is the "special" gecko installer wine searches for.
#
# The filename and checksum are hardcoded into wine.  Each wine
# version may require a different gecko MSI.  Gecko 2.40 is used by
# wine 1.7.50.
#
remote_file '/usr/share/wine/gecko/wine_gecko-2.40-x86.msi' do
  source 'http://downloads.sourceforge.net/project/wine/Wine%20Gecko/2.40/wine_gecko-2.40-x86.msi'
  checksum '1a29d17435a52b7663cea6f30a0771f74097962b07031947719bb7b46057d302'
  mode 0644
end 

package 'winetricks'
