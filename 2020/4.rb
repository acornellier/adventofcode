require_relative 'util'

input = File.read('4.input')

# 'cid' field is not required !
required_validation = {
  'byr' => ->(year) { (1920..2002).include?(year.to_i) },
  'iyr' => ->(year) { (2010..2020).include?(year.to_i) },
  'eyr' => ->(year) { (2020..2030).include?(year.to_i) },
  'hgt' => ->(height) do
    case height
    when /cm/
      height_number = height.gsub('cm', '').to_i
      (150..193).include?(height_number)
    when /in/
      height_number = height.gsub('in', '').to_i
      (59..76).include?(height_number)
    end
  end,
  'hcl' => ->(hair_color) { hair_color.match?(/#([0-9a-f]){6}$/) },
  'ecl' => ->(eye_color) do
    %w[amb blu brn gry grn hzl oth].include?(eye_color)
  end,
  'pid' => ->(pid) { pid.match?(/^[0-9]{9}$/) },
}
required_fields = required_validation.keys
arr_input = input.split("\n\n")

# Part 1
valid_passports_count =
  arr_input.count do |entry|
    fields = entry.gsub(/\n/, ' ').split
    hashed = Hash[fields.map { |field| field.split(':') }]

    required_fields.all? do |required_field|
      hashed.keys.include?(required_field)
    end
  end

puts "Part 1: there is #{valid_passports_count} valid passports"

# Part 2
p2_valid_passports_count =
  arr_input.count do |entry|
    fields = entry.gsub(/\n/, ' ').split
    hashed = Hash[fields.map { |field| field.split(':') }]

    all_required_fields_present =
      required_fields.all? do |required_field|
        hashed.keys.include?(required_field)
      end

    all_validations_pass =
      required_validation.all? do |key, validation|
        validation.call(hashed[key]) if hashed[key]
      end

    all_required_fields_present && all_validations_pass
  end

puts "Part 2: there is #{p2_valid_passports_count} valid passports"
