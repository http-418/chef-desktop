# Ubuntu 16.04 and above lack a KDM package.
dm = if node[:platform] == 'ubuntu' &&
         Gem::Version.new(node[:platform_version]) >= Gem::Version.new('16.04')
       'sddm'
     else
       'kdm'
     end

default['desktop']['display_manager'] = dm

