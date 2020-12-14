data = File.readlines('13-data.txt', chomp: true)
earliest = data[0].to_i
busses = data[1].split(',').map{ |id| id == 'x' ? 0 : id.to_i}

best_bus = nil
busses.each do |id|
  next if id == 0
  delay = id - (earliest % id)
  best_bus = [id, delay] if best_bus == nil || delay < best_bus[1]
  # puts "#{id}: #{delay}"
end

puts "Bus: #{best_bus[0]} arrives in #{best_bus[1]} minutes with id x minutes = #{best_bus[0]*best_bus[1]}"
