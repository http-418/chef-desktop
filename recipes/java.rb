#
# Cookbook Name:: desktop
# Recipe:: java
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

node.default[:java][:install_flavor] = 'oracle'
node.default[:java][:jdk_version] = '8'
node.default[:java][:oracle][:accept_oracle_download_terms] = true

include_recipe 'java'

java_alternatives 'oracle-java-alternatives' do
  java_location '/usr/lib/jvm/java-8-oracle-amd64'
  action :set
end

# Java 9 early access.
ark 'jdk-9-ea' do  
  action :put
  checksum '741d9fb69c2b5cfd62ea6b40a2211ec369e5ac11613b916bc6030579a803912e'
  path '/usr/lib/jvm'
  url 'http://www.java.net/download/jdk9/archive/' \
      '99/binaries/jdk-9-ea+99_linux-x64_bin.tar.gz'
end
