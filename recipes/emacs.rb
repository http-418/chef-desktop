#
# Cookbook Name:: desktop
# Recipe:: emacs
# Author:: Andrew Jones
#
# This recipe compiles a recent emacs release from git.
#

package [
  'build-essential',
  "autoconf",
  "automake",
  "autotools-dev",
  "bsd-mailx",
  "debhelper",
  "dpkg-dev",
  "imagemagick",
  "libasound2-dev",
  "libdbus-1-dev",
  "libgconf2-dev",
  "libgif-dev",
  "libgnutls-dev",
  "libgpm-dev",
  "libgtk-3-dev",
  "libjpeg-dev",
  "liblockfile-dev",
  "libm17n-dev",
  "libmagick++-dev",
  "libncurses5-dev",
  "libotf-dev",
  "libpng-dev",
  "librsvg2-dev",
  "libselinux1-dev",
  "libtiff5-dev",
  "libxaw7-dev",
  "libxml2-dev",
  "quilt",
  "sharutils",
  "texinfo",
  "xaw3dg-dev",
] do
  action :install
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
  revision 'emacs-24.5'
  action :sync
  notifies :run, 'execute[emacs-configure]'
end

execute 'emacs-configure' do
  cwd emacs_src_path
  command "./autogen.sh && ./configure --prefix=#{emacs_bin_path}"
  user node['desktop']['user']['name']
  notifies :run, 'execute[emacs-make]'
  action :nothing
end

execute 'emacs-make' do
  cwd emacs_src_path
  command 'make bootstrap && make'
  user node['desktop']['user']['name']
  notifies :run, 'execute[emacs-install]'
  action :nothing
end

execute 'emacs-install' do
  cwd emacs_src_path
  command 'make install'
  user node['desktop']['user']['name']
  action :nothing
end

Dir.new('/opt/emacs/bin').reject{|e| e[0] == '.'}.each do |bin|
  link "/usr/local/bin/#{bin}" do
    to "#{emacs_bin_path}/bin/#{bin}"
  end
end
