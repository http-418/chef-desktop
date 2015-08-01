# 
# I don't know where this firmware came from, or what it's for.  But BRCM bluetooth dongles don't work right without it.
#
directory '/lib/firmware/brcm' 

cookbook_file '/lib/firmware/brcm/BCM20702A0-0a5c-21e8.hcd' do
  mode 0444
  source 'BCM20702A0.hcd'
end
