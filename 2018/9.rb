class Node
  attr_accessor :prev, :next
  attr_reader :value

  def initialize(value, p = nil, n = nil)
    @value = value
    @prev = p
    @next = n
  end
end

class LinkedList
  def initialize
    @head = nil
  end

  def append(value)
    return append_after(@head.prev, value) unless @head.nil?
    @head = Node.new(value)
    @head.prev = @head
    @head.next = @head
  end

  def append_after(node, value)
    node.next = Node.new(value, node, node.next)
    node.next.next.prev = node.next
  end

  def delete(node)
    node.prev.next = node.next
    node.next.prev = node.prev
    @head = node.next if @head == node
    node.next
  end

  def print
    a = [@head.value]
    node = @head.next
    while node.value != @head.value
      a << node.value
      node = node.next
    end
    p a
  end
end

players, max_points = $<.read.scan(/\d+/).map(&:to_i)
board = LinkedList.new
player_scores = [0] * players

marbles = (1..max_points).to_a
cur = board.append(0)
cur_player = 0

until marbles.empty?
  marble = marbles.shift
  if marble % 23 == 0
    7.times { cur = cur.prev }
    player_scores[cur_player] += marble + cur.value
    cur = board.delete(cur)
  else
    board.append_after(cur.next, marble)
    cur = cur.next.next
  end

  cur_player = (cur_player + 1) % players
end

p player_scores.max
