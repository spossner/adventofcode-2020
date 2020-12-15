data = [20, 9, 11, 0, 1, 2]
last_seen = Hash.new(0)
data[0..-2].each_with_index { |n, i| last_seen[n] = i + 1 }

(30_000_000 - data.length).times do
  turn = data.length + 1
  last_number = data[-1]
  recent = last_seen[last_number]
  recent = (turn - 1 - recent) if recent > 0
  last_seen[data[-1]] = turn - 1
  data << recent
end
puts data[-1]
