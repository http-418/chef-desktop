#
# Cookbook Name:: desktop
# Recipe:: java
# Author:: Andrew Jones
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
ark "jdk-9-ea" do  
  action :put
  checksum '741d9fb69c2b5cfd62ea6b40a2211ec369e5ac11613b916bc6030579a803912e'
  path '/usr/lib/jvm'
  url 'http://www.java.net/download/jdk9/archive/99/binaries/jdk-9-ea+99_linux-x64_bin.tar.gz'
end
