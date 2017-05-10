if ENV['SUDO_UID'] && ENV['SUDO_GID']
  require 'etc'

  default['desktop']['user'].tap do |user|
    user['name'] = Etc.getpwuid(ENV['SUDO_UID'].to_i).name
    user['uid'] = ENV['SUDO_UID']
    user['group'] = Etc.getgrgid(ENV['SUDO_GID'].to_i).name
    user['gid'] = ENV['SUDO_GID']
    user['home'] = Etc.getpwuid(ENV['SUDO_UID'].to_i).dir
  end
else
  default['desktop']['user'].tap do |user|
    user['name'] = 'ajones'
    user['uid'] = '1000'
    user['group'] = 'ajones'
    user['gid'] = '1000'
    user['home'] = '/home/ajones'
  end
end
