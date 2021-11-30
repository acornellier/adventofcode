require_relative 'util'

input = File.read(ARGV[0])
lines = input.split("\n").map(&:chomp)

SIZE = 25

nums = lines.map(&:to_i)

nums.each.with_index do |num, i|
  next unless i >= SIZE

  good = nums[(i - SIZE)...i].combination(2).any? { |x, y| (x + y == num) }

  unless good
    puts "#{num} is not good"

    (0...i).each do |j|
      (j...i).each do |k|
        if nums[j..k].sum == num
          p nums[j..k].min + nums[j..k].max
          exit
        end
      end
    end
    raise
  end
end
