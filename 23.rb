# input = "32415"
#input = "389125467"
input = "716892543"
moves = 100
data = input.split('').map { |s| s.to_i }
current = data[0]
n = data.length
moves.times do |i|
  puts "-- move #{i+1} --"
  ptr = data.find_index(current)
  puts "cups: #{data.each_with_index.map { |v, i| i == ptr ? "(#{v})" : v.to_s }.join(" ")}"
  if ptr < data.length-4
    selection = data.slice!(ptr + 1, 3)
  else
    puts "#{ptr}, #{data.length}"
    selection = data.slice!(ptr + 1..-1) # slice to end
    selection += data.slice!(0, 3-selection.length)
  end
  puts "pick up: #{selection.join(" ")}"
  destination = current
  pos = nil
  while pos.nil?
    destination = destination > data.min ? destination - 1 : data.max
    pos = data.find_index(destination)
  end
  puts "destination: #{destination}"
  data.insert(pos - data.length, *selection)
  current = data[(data.find_index(current) + 1) % n]
end

ptr = data.find_index(1)
result = []
result += data.slice!(ptr + 1..-1) if ptr < data.length-1
result += data.slice!(0..-2)
puts result.join("")