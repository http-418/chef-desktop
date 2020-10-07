module BeforeVersionHelper
  def debian_before(version)
    node[:lsb][:id] == 'Debian' &&
      Gem::Version.new(node[:lsb][:release]) < Gem::Version.new(version)
  end

  def ubuntu_before(version)
    node[:lsb][:id] == 'Ubuntu' &&
      Gem::Version.new(node[:lsb][:release]) < Gem::Version.new(version)
  end
end

Chef::Recipe.send(:include, BeforeVersionHelper)
Chef::Resource.send(:include, BeforeVersionHelper)
