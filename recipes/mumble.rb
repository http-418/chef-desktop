include_recipe 'desktop::apt'

package ['mumble', 'mumble-server', 'certbot'] do
  action :upgrade
end
