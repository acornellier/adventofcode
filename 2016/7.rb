require_relative 'util'
lines = $stdin.read.strip.split("\n")

def split_word(s)
  (0..s.length)
    .inject([]) do |ai, i|
      (1..s.length - i).inject(ai) { |aj, j| aj << s[i, j] }
    end
    .uniq
end

def find(word)
  split_word(word).select do |substr|
    substr.size == 3 && substr == substr.reverse && substr[0] != substr[1] &&
      substr[0] == substr[2]
  end
end

floating_address =
  lines.count do |line|
    words = line.split(/\[|\]/)
    matches = [[], []]
    words.each.with_index { |word, i| matches[i % 2] += find(word) }
    matches[0]
      .any? do |aba|
        matches[1].any? { |bab| aba[0] == bab[1] && aba[1] == bab[0] }
      end
      .tap { |r| p [line, matches, r] }
  end

p floating_address
