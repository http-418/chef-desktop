#
# Cookbook Name:: desktop
# Recipe:: git
#
# Copyright 2017 Andrew Jones
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
# Pin a modern version of git, because trusty and jessie come with an
# ancient version.
#
if node['platform'] == 'ubuntu'
  include_recipe 'desktop::backports'

  if Gem::Version.new(node[:lsb][:release]) < Gem::Version.new('16.04')
    apt_preference 'ubuntu-xenial' do
      glob '*'
      pin 'release n=xenial'
      pin_priority '100'
    end

    apt_preference 'ubuntu-xenial-git' do
      glob 'git'
      pin 'release n=xenial'
      pin_priority '710'
    end

    apt_repository 'xenial' do
      uri node[:ubuntu][:archive_url]
      distribution 'xenial'
      components ['main']
    end
  else
    # Delete the preferences, if present, on 16.04 and above.
    apt_preference 'ubuntu-xenial' do
      action :remove
    end

    apt_preference 'ubuntu-xenial-git' do
      action :remove
    end
  end
end

if node[:lsb][:id] == 'Debian'
  if Gem::Version.new(node[:lsb][:release]) < Gem::Version.new('9.0')
    include_recipe 'desktop::stretch'

    apt_preference 'debian-stretch-git' do
      glob 'git'
      pin 'release n=stretch'
      pin_priority '710'
    end
  else
    apt_preference 'debian-stretch-git' do
      action :remove
    end
  end
end

package 'git' do
  action :upgrade
end
