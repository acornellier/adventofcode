require_relative "util"
require_relative "input"

# @example_extension = "ex1"
# @type [Array<String>]
# lines = get_input_str_arr(__FILE__)
# @type [Array<Array<String>>]
groups = str_groups_separated_by_blank_lines(__FILE__)

def range_intersect(a, b)
  s = [a.begin, b.begin].max
  e = [a.end, b.end].min
  s <= e ? (s..e) : nil
end

def extract_range(range, intersection)
  res = []
  if range.begin < intersection.begin
    res << (range.begin..intersection.begin - 1)
  end
  if range.end > intersection.end
    res << (intersection.end + 1..range.end)
  end
  res
end

maps = groups[1..].map do |group|
  group[1..].to_h do |line|
    dest, source, len = line.scan(/\d+/).map(&:to_i)
    [source..source + len - 1, dest..dest + len - 1]
  end.sort_by { |k,| k.begin }.to_h
end

while maps.size > 1
  merged_map = {}
  group2 = maps.pop
  group1 = maps.pop

  group1_new = group1.dup
  group2_new = group2.dup

  done = false
  until done
    intersection = nil
    found_source1 = nil
    found_dest1 = nil
    found_source2, found_dest2 = group2_new.find do |source2, dest2|
      found_source1, found_dest1 = group1_new.find do |source1, dest1|
        intersection = range_intersect(dest1, source2)
      end
    end

    break unless intersection and found_source1 and found_dest1

    dist1 = found_dest1.begin - found_source1.begin
    dist2 = found_dest2.begin - found_source2.begin

    new_dests1 = extract_range(found_dest1, intersection)
    new_sources2 = extract_range(found_source2, intersection)

    group1_new.delete(found_source1)
    group2_new.delete(found_source2)

    new_dests1.each do |new_dest|
      new_source1 = new_dest.begin - dist1..new_dest.end - dist1
      group1_new[new_source1] = new_dest
    end

    new_sources2.each do |new_source|
      new_dest2 = new_source.begin + dist2..new_source.end + dist2
      group2_new[new_source] = new_dest2
    end

    mapped_source1 = intersection.begin - dist1..intersection.end - dist1
    mapped_dest2 = intersection.begin + dist2..intersection.end + dist2
    merged_map[mapped_source1] = mapped_dest2
  end

  merged_map.merge!(group1_new)
  merged_map.merge!(group2_new)

  maps << merged_map.sort_by { |k,| k.begin }.to_h
end

final_map = maps[0].to_h { |k, v| [k, v.begin - k.begin] }
p final_map

seed_ranges = groups[0][0].scan(/\d+/).map(&:to_i).each_slice(2).flat_map { (_1..._1 + _2) }.sort_by { |k,| k.begin }
p seed_ranges

min = Float::INFINITY
seed_ranges.map do |seed_range|
  remaining_seed_range = seed_range

  until remaining_seed_range.nil?
    intersection = nil
    found_source, found_diff = final_map.find do |source, diff|
      intersection = range_intersect(source, remaining_seed_range)
    end

    unless intersection
      min = [min, remaining_seed_range.end].min
      remaining_seed_range = nil
      next
    end

    min = [min, intersection.begin + found_diff, intersection.end + found_diff].min
    remaining_seed_range = intersection.end + 1..remaining_seed_range.end
  end
end

p min
