#
# Copyright 2020 Andrew Jones
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
# Stub policyfile for the 'desktop' cookbook.
#
# You probably don't want to actually use this, unless you are working
# with cinc-workstation and test-kitchen.
#

name 'desktop'
run_list 'desktop'
default_source :supermarket
cookbook 'desktop', path: '.'
named_run_list :kde, 'desktop::kde'
named_run_list :wine, 'desktop::wine'
