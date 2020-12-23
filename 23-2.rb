class Node
  attr_accessor :value, :next_node
  def initialize(value, prev_node = nil)
    @value = value
    @next_node = nil
    prev_node.next_node = self unless prev_node.nil?
  end

  def cut_after(n = 3)
    raise "can not cut less than 1 node: #{n}" if n < 1
    node = self
    n.times { node = node.next_node }
    chain = @next_node
    @next_node = node.next_node # skip the next n nodes
    node.next_node = nil # clear the next node of the cutted chain
    chain
  end

  def insert_after(node)
    node.tail.next_node = @next_node
    @next_node = node
  end

  def tail
    node = self
    until node.next_node.nil?
      node = node.next_node
    end
    node
  end

  def include?(n)
    node = self
    loop do
      return true if node.value == n
      node = node.next_node
      break if node == nil || node == self
    end
    false
  end

  def to_s
    result = "#{@value}"
    node = self
    8.times do
      node = node.next_node
      break if node == nil
      result += " #{node.value}"
    end
    result
  end
end

# input = "32415"
input = "716892543"

#input = "389125467"
lower, upper = 1, 1000000
moves = 10000000
# lower, upper = 1, 9
# moves = 100

nodes = Hash.new # i => Node
node = nil
first_node = nil
data = input.split('').map do |s|
  i = s.to_i
  node = Node.new(s.to_i, node)
  first_node = node if first_node.nil?
  nodes[i] = node
end
(10..upper).each do |i|
  node = Node.new(i, node)
  nodes[i] = node
end
node.next_node = first_node # close the circle
node = first_node

moves.times do |i|
  puts "-- move #{i+1} --" if i % 100000 == 0
  # ptr = data.find_index(current)
  # puts "cups: #{node}"

  chain = node.cut_after
  # puts "pick up: #{chain}"


  destination = node.value
  loop do
    destination = destination > lower ? destination - 1 : upper
    break if !chain.include?(destination)
  end
  # puts "destination: #{destination}"
  target = nodes[destination]
  target.insert_after(chain)

  node = node.next_node
end

one = nodes[1]
puts one.to_s
v1 = one.next_node.value
v2 = one.next_node.next_node.value

puts "#{v1} x #{v2} = #{v1*v2}"