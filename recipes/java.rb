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
