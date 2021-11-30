lines = File.readlines('input.txt').map(&:strip)

steps = lines.map { |line| [line[5], line[36]] }

letters = steps.flatten.uniq

h1 = letters.each_with_object({}) { |letter, h| h[letter] = [] }

steps.each { |step| h1[step[1]] << step[0] }

pending = {}
completed = []
workers = 5
seconds = 0

loop do
  pending.each do |k, v|
    pending[k] -= 1
    if pending[k] == 0
      completed << k
      pending.delete(k)
      workers += 1
    end
  end

  break if completed.length == letters.length

  potential = []
  h1.each do |a, b|
    next if completed.include? a
    potential << a if (b - completed).empty?
  end

  potential.each do |step|
    next if completed.include?(step) || pending[step]
    break if workers == 0
    pending[step] = 60 + step.ord - 'A'.ord + 1
    workers -= 1
  end
  seconds += 1
end

p seconds
