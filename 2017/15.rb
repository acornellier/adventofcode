lines = $stdin.read.strip.split("\n")

a = 516
b = 190

# a = 65
# b = 8921

A = 16_807
B = 48_271
Q = 2_147_483_647

count = 0
5_000_000.times do |n|
  p n if n % 1_000_000 == 0
  begin
    a = (a * A) % Q
  end until a % 4 == 0
  begin
    b = (b * B) % Q
  end until b % 8 == 0

  count += 1 if a % 65_536 == b % 65_536
end

p count
