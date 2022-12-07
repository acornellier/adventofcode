require_relative 'input'

lines = get_input_str_arr(__FILE__)

files = { 'files' => [] }
cur_path = []

lines.each do |line|
  a, b, c = line.split

  if a == '$'
    next if b == 'ls'

    if c == '/'
      cur_path.clear
    elsif c == '..'
      cur_path = cur_path[0..-2]
    else
      d = files
      cur_path.each { d = d[_1] }
      d[c] ||= {}
      d[c]['files'] ||= []
      cur_path << c
    end
  else
    next if a == 'dir'
    d = files
    cur_path.each { d = d[_1] }
    d['files'] << a.to_i
  end
end

$all_folder_sizes = []

def size_of_folder(contents)
  contents.sum do |name2, contents2|
    next contents2.sum if name2 == 'files'
    size_of_folder = size_of_folder(contents2)
    $all_folder_sizes << size_of_folder
    size_of_folder
  end
end

root_size = size_of_folder(files)
p $all_folder_sizes.select { _1 <= 100000 }.sum

unused_space = 70000000 - root_size
min_to_delete = 30000000 - unused_space
p $all_folder_sizes.sort.find { _1 >= min_to_delete }

