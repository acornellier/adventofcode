require_relative 'util/grid'
lines = $stdin.read.strip.split("\n")

def split_word s
  (0..s.length).inject([]){|ai,i|
    (1..s.length - i).inject(ai){|aj,j|
      aj << s[i,j]
    }
  }.uniq
end

def find(word)
  split_word(word).select do |substr|
    substr.size == 3 && substr == substr.reverse && substr[0] != substr[1] && substr[0] == substr[2]
  end
end

res = lines.count do |line|
  words = line.split(/\[|\]/)
  matches = [[], []]
  words.each.with_index do |word, i|
    matches[i % 2] += find(word)
  end
  matches[0].any? do |aba|
    matches[1].any? do |bab|
      aba[0] == bab[1] && aba[1] == bab[0]
    end
  end.tap { |r| p [line, matches, r] }
end

p res