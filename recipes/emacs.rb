#
# Cookbook Name:: desktop
# Recipe:: emacs
#
# Copyright 2016 Andrew Jones
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# This recipe compiles a recent emacs release from git. elpa/melpa
# support for old versions of emacs is spotty at best.  It's
# important to be no more than a year or two behind.
#
include_recipe 'desktop::apt'
include_recipe 'desktop::fonts'
include_recipe 'desktop::user'

package [
  'build-essential',
  'autoconf',
  'automake',
  'autotools-dev',
  'bsd-mailx',
  'debhelper',
  'dpkg-dev',
  'imagemagick',
  'libasound2-dev',
  'libdbus-1-dev',
  'libgconf2-dev',
  'libgif-dev',
  'libgnutls28-dev',
  'libgpm-dev',
  'libgtk-3-dev',
  'libjpeg-dev',
  'liblockfile-dev',
  'libm17n-dev',
  'libmagick++-dev',
  'libncurses5-dev',
  'libotf-dev',
  'libpng-dev',
  'librsvg2-dev',
  'libselinux1-dev',
  'libtiff5-dev',
  'libxaw7-dev',
  'libxml2-dev',
  'quilt',
  'sharutils',
  'texinfo',
  'xaw3dg-dev',
] do
  action :install
end

emacs_bin_path = '/opt/emacs'
emacs_src_path = '/usr/local/src/emacs'

directory emacs_bin_path do
  user node['desktop']['user']['name']
  group node['desktop']['user']['group']
end

directory emacs_src_path do
  user node['desktop']['user']['name']
  group node['desktop']['user']['group']
end

git emacs_src_path do
  repository 'http://git.savannah.gnu.org/r/emacs.git'
  user node['desktop']['user']['name']
  group node['desktop']['user']['group']
  revision 'emacs-26.1'
  action :sync
  notifies :run, 'execute[emacs-configure]', :immediately
end

execute 'emacs-configure' do
  cwd emacs_src_path
  command "./autogen.sh && ./configure --prefix=#{emacs_bin_path}"
  user node['desktop']['user']['name']
  action :nothing
  notifies :run, 'execute[emacs-make]', :immediately
end

execute 'emacs-make' do
  cwd emacs_src_path
  command 'make -j $(nproc) bootstrap && make -j $(nproc)'
  user node['desktop']['user']['name']
  action :nothing
  notifies :run, 'execute[emacs-install]', :immediately
end

execute 'emacs-install' do
  cwd emacs_src_path
  command 'make install'
  user node['desktop']['user']['name']
  action :nothing
end

ruby_block 'emacs-bin-symlinks' do
  block do
    Dir.new("#{emacs_bin_path}/bin").reject{|e| e[0] == '.'}.each do |bin|
      link = Chef::Resource::Link.new("/usr/local/bin/#{bin}", run_context)
      target = "#{emacs_bin_path}/bin/#{bin}"
      link.to(target)
      link.run_action(:create)
    end
  end
end

package [
  'emacs',
  'emacs24',
  'emacs24-bin-common',
  'emacs24-common',
  'emacs24-common-non-dfsg',
  'emacs24-lucid',
  'emacs24-nox',
] do
  action :remove
end
