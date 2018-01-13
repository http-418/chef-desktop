#
# Cookbook Name:: desktop
# Recipe:: spotify
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
include_recipe 'desktop::libgcrypt11'

package 'dirmngr'

apt_repository 'spotify' do
  uri 'http://repository.spotify.com'
  components ['non-free']
  distribution 'stable'
  keyserver 'keyserver.ubuntu.com'
  key '0DF731E45CE24F27EEEB1450EFDC8610341D9410'
end

package 'spotify-client'
