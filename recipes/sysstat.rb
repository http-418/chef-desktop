#
# recipes/sysstat.rb
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
# Configures sar/sadc on Debian Linux.
#
include_recipe 'desktop::apt'
include_recipe 'desktop::cron'

package 'sysstat' do
  action :upgrade
end

file '/etc/default/sysstat' do
  user 'root'
  group 'root'
  mode 0444
  content <<-EOM.gsub(/^ {4}/, '')
    #
    # /etc/default/sysstat
    #
    # This file was installed by Chef.
    # Local changes will be reverted.
    #
    # Default settings for /etc/init.d/sysstat, /etc/cron.d/sysstat
    # and /etc/cron.daily/sysstat files
    #
    ENABLED="true"
  EOM
end

file '/etc/cron.d/sysstat' do
  user 'root'
  group 'root'
  mode 0444
  content <<-EOM.gsub(/^ {4}/, '')
    #
    # /etc/cron.d/sysstat
    #
    # This file was installed by Chef.
    # Local changes will be reverted.
    #

    PATH=/usr/lib/sysstat:/usr/sbin:/usr/sbin:/usr/bin:/sbin:/bin

    # Activity reports every 2 minutes everyday
    2-58/2 * * * * root command -v debian-sa1 > /dev/null && debian-sa1 1 1

    # Additional run at 23:59 to rotate the statistics file
    59 23 * * * root command -v debian-sa1 > /dev/null && debian-sa1 60 2
  EOM
end
