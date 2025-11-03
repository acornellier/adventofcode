require_relative 'util'
require_relative 'input'

@example_extension = 'ex1'

# @type [Array<String>]
lines = get_input_str_arr(__FILE__)
# @type [Array<Array<String>>]
# groups = str_groups_separated_by_blank_lines(__FILE__)

cards_step2 = %w(A K Q T 9 8 7 6 5 4 3 2 J)

types = [
  {
    type: 'five_of_a_kind',
    check: ->(hand) { hand.tally.values.include?(5) },
    check_joker: ->(hand) {
      hand.tally.values.include?(5) ||
        hand.reject { _1 == 'J' }.tally.values.include?(5 - hand.count('J'))
    },
  },
  {
    type: 'four_of_a_kind',
    check: ->(hand) { hand.tally.values.include?(4) },
    check_joker: ->(hand) {
      hand.reject { _1 == 'J' }.tally.values.include?(4 - hand.count('J'))
    },
  },
  {
    type: 'full_house',
    check: ->(hand) {
      hand.tally.values.sort == [2, 3]
    },
    check_joker: ->(hand) {
      jokers = hand.count('J')
      counts = hand.reject { _1 == 'J' }.tally.values.sort
      case counts
      when [3]
        jokers >= 2
      when [2, 2]
        jokers >= 1
      when [2, 3]
        true
      else
        false
      end
    },
  },
  {
    type: 'three_of_a_kind',
    check: ->(hand) { hand.tally.values.include?(3) },
    check_joker: ->(hand) {
      hand.reject { _1 == 'J' }.tally.values.include?(3 - hand.count('J'))
    },
  },
  {
    type: 'two_pair',
    check: ->(hand) { hand.tally.values.count { |v| v == 2 } >= 2 },
    check_joker: ->(hand) {
      jokers = hand.count('J')
      hand.reject { _1 == 'J' }.tally.values.count(2) + jokers >= 2
    },
  },
  {
    type: 'one_pair',
    check: ->(hand) { hand.tally.values.include?(2) },
    check_joker: ->(hand) {
      hand.reject { _1 == 'J' }.tally.values.include?(2 - hand.count('J'))
    },
  },
  {
    type: 'high_card',
    check: ->(_) { true },
    check_joker: ->(_) { true },
  },
]

hand_bids = lines.to_h do |line|
  hand, bid = line.split
  [hand, bid.to_i]
end

sorted_hands = hand_bids.keys.map(&:chars).sort do |hand1, hand2|
  type1 = types.find_index { |t| t[:check_joker].call(hand1) }
  type2 = types.find_index { |t| t[:check_joker].call(hand2) }
  next type2 <=> type1 if type1 != type2

  res = 0
  hand1.zip(hand2).each do |card1, card2|
    rank1 = cards_step2.index(card1)
    rank2 = cards_step2.index(card2)
    if rank1 != rank2
      res = rank2 <=> rank1
      break
    end
  end
  res
end.map(&:join)

res = sorted_hands.each_with_index.sum do |hand, idx|
  rank = idx + 1
  bid = hand_bids[hand]
  bid * rank
end

p "Step 2: #{res}"