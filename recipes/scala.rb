#
# Cookbook Name:: desktop
# Recipe:: scala
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
# Typesafe (now known as Lightbend) used to provide a signed apt
# repository with a complete scala stack in it.  They no longer
# provide that repository, only individual package downloads. 
#
# Unfortunately, that means hardcoding a version and a checksum.
#
include_recipe 'apt'
include_recipe 'desktop::java'

deb_path = ::File.join(Chef::Config.file_cache_path, 'scala-2.11.deb')

remote_file deb_path do
  source 'http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.deb'
  checksum 'd7335d2448cfed038f0cd79ed946ce82883651b80e4b698031261df23d9cb662'
end

dpkg_package deb_path
                          
