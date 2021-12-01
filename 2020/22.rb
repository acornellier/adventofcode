require_relative 'util'
require_relative 'input'

# @example_extension = 'ex1'
groups = str_groups_separated_by_blank_lines(__FILE__)

player_1 = groups[0][1..].map(&:to_i)
player_2 = groups[1][1..].map(&:to_i)

def play(player_1, player_2)
  completed_games = Set.new
  loop do
    card_1 = player_1.shift
    card_2 = player_2.shift

    winner = nil
    if completed_games.include?([player_1, player_2].hash)
      return 1, player_1
    elsif player_1.size >= card_1 && player_2.size >= card_2
      winner, = play(player_1.dup.take(card_1), player_2.dup.take(card_2))
    else
      winner = card_1 > card_2 ? 1 : 2
    end

    completed_games << [player_1, player_2].hash

    if winner == 1
      player_1 += [card_1, card_2]
    else
      player_2 += [card_2, card_1]
    end

    return 1, player_1 if player_2.size == 0
    return 2, player_2 if player_1.size == 0
  end
end

winner, deck = play(player_1, player_2)

p deck.reverse.map.with_index(1) { |card, index| card * index }.sum
