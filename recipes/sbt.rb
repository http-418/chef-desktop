#
# Cookbook Name:: desktop
# Recipe:: sbt
#
# Copyright 2015 Andrew Jones
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

include_recipe 'apt'
include_recipe 'desktop::java'

apt_repository 'sbt' do
  uri 'https://dl.bintray.com/sbt/debian'
  components ['/']
  distribution ''
  key '2EE0EA64E40A89B84B2DF73499E82A75642AC823'
  keyserver 'keyserver.ubuntu.com'
  action :add
  notifies :run, 'execute[apt-get update]', :immediately
end

package 'sbt' do
  action :upgrade
end
