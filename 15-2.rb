def last_spoken(data, n)
  last_seen = Hash.new(0)
  data[0..-2].each_with_index { |n, i| last_seen[n] = i + 1 } # assuming 3 or more starting numbers
  (n - data.length).times do |i|
    turn = data.length + 1
    last_number = data[-1]
    recent = last_seen[last_number]
    recent = (turn - 1 - recent) if recent > 0
    last_seen[data[-1]] = turn - 1
    data << recent
    print '.' if i % (n/40) == 0
  end
  print '.'
  data[-1]
end
puts last_spoken([0, 3, 6], 2020)
puts last_spoken([20, 9, 11, 0, 1, 2], 2020)
puts last_spoken([20, 9, 11, 0, 1, 2], 30_000_000)
