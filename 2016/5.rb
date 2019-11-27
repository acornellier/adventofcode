require_relative 'util/grid'
lines = $stdin.read.strip.split("\n")

require 'digest'
idx = 0

password = {}
until password.size == 8
  md5 = Digest::MD5.hexdigest('cxdnnyjw' + idx.to_s)
  if md5.start_with?('00000') && md5[5] >= '0' && md5[5] <= '7'
    pos = md5[5].to_i
    unless password[pos]
      password[md5[5].to_i] = md5[6]
      p password.keys.sort.map { |n| password[n] }.join
    end
  end
  idx += 1
end
