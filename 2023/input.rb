YEAR = 2023
COOKIE_FILE = "#{YEAR}/cookie"

@example_extension = nil

def strip_newlines(strs)
  strs.map { |str| str.delete_suffix("\n") }
end

# @return [Array<String>]
def get_input_str_arr(original_filename)
  day = File.basename(original_filename).chomp('.rb')
  dot_slash_date = "#{YEAR}/#{day}"

  if @example_extension
    file = "#{dot_slash_date}.#{@example_extension}"
    strip_newlines(File.readlines(file))
  else
    true_input_filename = "#{dot_slash_date}.input"
    true_input = nil

    if File.exist?(true_input_filename)
      true_input = strip_newlines(File.readlines("#{dot_slash_date}.input"))
    end

    unless true_input
      puts "Fetching input for day #{day}..."

      # Call .to_i.to_s to get rid of leading 0 for Dec. 1-9.
      cookie = File.read(COOKIE_FILE).strip

      curl_command =
        "curl https://adventofcode.com/#{YEAR}/day/#{day}/input " \
          "-H \"cache-control: max-age=0\" " \
          "-H \"cookie: #{cookie}\" " \
          "--output #{true_input_filename} "

      system(curl_command)

      true_input = strip_newlines(File.readlines("#{dot_slash_date}.input"))
    end

    if true_input.empty? ||
      true_input[0].start_with?("Please don't repeatedly request") ||
      true_input[0] == '404 Not Found'
      puts "Input for day #{dot_slash_date} was fetched prematurely..."
      exit(1)
    end

    true_input
  end
end

# For input like:
# a
# b
#
# abc
#
# a
# b
# c
def str_groups_separated_by_blank_lines(original_filename)
  groups = []
  curr_group = []

  get_input_str_arr(original_filename).each do |str|
    if str == ''
      groups << curr_group
      curr_group = []
      next
    end

    curr_group << str
  end

  groups << curr_group
  groups
end

# For input like:
# here-is-some-text
def get_input_str(original_filename)
  get_input_str_arr(original_filename)[0]
end

# For input like:
# 1,2,3
def get_single_line_input_int_arr(original_filename, separator: ',')
  get_input_str(original_filename).split(separator).map(&:to_i)
end

# For input like:
# 1
# 2
# 3
def get_multi_line_input_int_arr(original_filename)
  get_input_str_arr(original_filename).map(&:to_i)
end
