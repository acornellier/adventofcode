require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'

lines = get_input_str_arr(__FILE__)

WALL = '#'
OPEN = '.'
@energy = { ?A => 1, ?B => 10, ?C => 100, ?D => 1000 }

cubby_size = 4
rooms = [3, 5, 7, 9]
cubbies = lines[2].chars.values_at(*rooms)
                  .zip(
                    lines[3].chars.values_at(*rooms),
                    lines[4].chars.values_at(*rooms),
                    lines[5].chars.values_at(*rooms)
                  )
cubby_exits = rooms.map { _1 - 1 }
hallway_size = 11
hallway = [nil] * hallway_size
@possible_destinations = (0...hallway.size).to_a - cubby_exits

initial_state = {
  cubbies:,
  hallway:,
  moved_cubbies: [[false] * cubby_size] * 4,
  energy: 0,
}

def correct_dude?(dude, cubby_idx)
  dude && dude.ord - ?A.ord == cubby_idx
end

exit_condition = ->(state) do
  state[:cubbies].each.with_index.all? do |cubby, cubby_idx|
    cubby.all? { |dude| correct_dude?(dude, cubby_idx) }
  end
end

neighbors = ->(state) do
  neighbor_states = []
  cubbies, hallway, moved_cubbies, energy =
    state.fetch_values(:cubbies, :hallway, :moved_cubbies, :energy)

  cubbies.each.with_index do |cubby, cubby_idx|
    cubby_slot = cubby.index { _1 }
    next unless cubby_slot
    next if moved_cubbies[cubby_idx][cubby_slot]
    next if cubby[cubby_slot..].all? { correct_dude?(_1, cubby_idx) }

    dude = cubby[cubby_slot]
    cubby_exit = cubby_exits[cubby_idx]

    @possible_destinations.each do |hallway_idx|
      min = [cubby_exit, hallway_idx].min
      max = [cubby_exit, hallway_idx].max
      next if (min..max).any? { hallway[_1] }

      new_cubbies = cubbies.map(&:dup)
      new_cubbies[cubby_idx][cubby_slot] = nil

      new_hallway = hallway.dup
      new_hallway[hallway_idx] = dude

      moves = 0
      moves += cubby_slot
      moves += 1
      moves += (hallway_idx - cubby_exit).abs
      new_energy = energy + moves * @energy[dude]

      neighbor_states << {
        cubbies: new_cubbies,
        hallway: new_hallway,
        moved_cubbies:,
        energy: new_energy
      }
    end
  end

  hallway.each.with_index do |dude, hallway_idx|
    next unless dude

    cubby_idx = dude.ord - ?A.ord
    cubby = cubbies[cubby_idx]
    cubby_slot = (0...cubby_size).to_a.reverse.find { |i| cubby[i].nil? }
    next unless cubby_slot
    next if cubby[cubby_slot + 1..].any? { !correct_dude?(_1, cubby_idx) }

    cubby_exit = cubby_exits[cubby_idx]
    min = [cubby_exit, hallway_idx].min
    max = [cubby_exit, hallway_idx].max
    next if (min..max).any? { hallway[_1] && _1 != hallway_idx }

    new_cubbies = cubbies.map(&:dup)
    new_cubbies[cubby_idx][cubby_slot] = dude

    new_hallway = hallway.map(&:dup)
    new_hallway[hallway_idx] = nil

    new_moved_cubbies = moved_cubbies.map(&:dup)
    new_moved_cubbies[cubby_idx][cubby_slot] = true

    moves = 0
    moves += cubby_slot
    moves += 1
    moves += (hallway_idx - cubby_exit).abs
    new_energy = energy + moves * @energy[dude]

    neighbor_states << {
      cubbies: new_cubbies,
      hallway: new_hallway,
      moved_cubbies: new_moved_cubbies,
      energy: new_energy
    }
  end

  neighbor_states
end

distance = ->(state, neighbor) do
  neighbor[:energy] - state[:energy]
end

estimate_remaining = ->(state) do
  remaining = 0

  state[:cubbies].each.with_index do |cubby, cubby_idx|
    cubby.each.with_index do |dude, cubby_slot|
      next unless dude
      next if cubby[cubby_slot..].all? { correct_dude?(_1, cubby_idx) }

      wanted_cubby_idx = dude.ord - ?A.ord
      cur_cubby_exit = cubby_exits[cubby_idx]
      wanted_cubby_exit = cubby_exits[wanted_cubby_idx]
      remaining += (cubby_slot + 1 + (wanted_cubby_exit - cur_cubby_exit).abs + 1) * @energy[dude]
    end
  end

  state[:hallway].each.with_index do |dude, hallway_idx|
    next unless dude

    cubby_idx = dude.ord - ?A.ord
    cubby_exit = cubby_exits[cubby_idx]
    remaining += ((cubby_exit - hallway_idx).abs + 1) * @energy[dude]
  end

  remaining
end

dijkstra(
  initial_state,
  exit_condition,
  neighbors,
  distance,
  estimate_remaining,
)
