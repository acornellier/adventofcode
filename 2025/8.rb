require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)

boxes = lines.map { _1.split(',').map(&:to_i) }
dists = boxes.map.with_index { [_2] + _1 }.combination(2).map do |(i, x1, y1, z1), (j, x2, y2, z2)|
  [i, j, (x2 - x1) ** 2 + (y2 - y1) ** 2 + (z2 - z1) ** 2]
end.sort_by { _3 }

box_circuit_ids = (0...boxes.size).to_h { [_1, _1] }
circuits_by_id = box_circuit_ids.transform_values { Set.new([_1]) }
dists.each do |i, j|
  circuit_i_id = box_circuit_ids[i]
  circuit_j_id = box_circuit_ids[j]
  next if circuit_i_id == circuit_j_id

  circuit_i = circuits_by_id[circuit_i_id]
  circuit_j = circuits_by_id[circuit_j_id]

  if circuit_j.size > circuit_i.size
    circuit_i_id, circuit_j_id = circuit_j_id, circuit_i_id
    circuit_i, circuit_j = circuit_j, circuit_i
  end

  circuit_j.each do |box|
    box_circuit_ids[box] = circuit_i_id
  end
  circuits_by_id[circuit_i_id].merge(circuit_j)
  circuits_by_id.delete(circuit_j_id)

  if circuits_by_id.size == 1
    p boxes[i][0] * boxes[j][0]
    exit
  end
end
