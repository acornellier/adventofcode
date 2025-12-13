require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)

machines = lines.map do |line|
  lights, *buttons, joltage = line.split
  lights = lights[1..-2].chars.map { _1 == '#' }
  buttons.map! do |button|
    button[1..-2].split(',').map(&:to_i)
  end
  joltage = joltage[1..-2].split(',').map(&:to_i)
  [lights, buttons, joltage]
end

i = 0
res = machines.sum do |lights, buttons, joltage|
  i += 1
  puts "#{i}/#{machines.size}"
  buttons = buttons.sort_by(&:size).reverse
  initial_state = joltage
  exit_condition = ->(state) { state.all?(0) }

  press_button = ->(state, button, presses) do
    neighbor = state.dup
    return nil unless button.all? do |index|
      neighbor[index] -= presses
      neighbor[index] >= 0
    end
    [neighbor, presses]
  end

  neighbors = ->(state) do
    (0...state.size).each do |i|
      (0...state.size).each do |j|
        next unless state[i] > state[j]
        rebalance_buttons = buttons.select do |button|
          button.include?(i) && !button.include?(j)
        end
        return [] if rebalance_buttons.empty?
        if rebalance_buttons.size == 1
          neighbor_press = press_button.call(state, rebalance_buttons[0], state[i] - state[j])
          return neighbor_press ? [neighbor_press] : []
        end
      end
    end

    # lowest_idx = state.index(state.min)
    # buttons_affecting_lowest = buttons.select { _1.include?(lowest_idx) }
    # (0...state.size).each do |idx|
    #   next if idx == lowest_idx
    #   next unless buttons_affecting_lowest.all? { _1.include?(idx) }
    #   if state[lowest_idx] > state[idx]
    #     return []
    #   end
    # end

    buttons.filter_map do |button|
      press_button.call(state, button, 1)
    end
  end

  estimate_remaining = ->(state) do
    state.sum
  end

  s = Time.now
  sum = dijkstra(
    initial_state,
    exit_condition,
    neighbors,
    estimate_remaining:
  )
  p [i, sum, Time.now - s]
  sum
end

p res
