def convert_id(id)
  bId = id.chars.map { |c| c == 'F' || c == 'L' ? '0' : '1' }.join
  row = bId[0..6].to_i(2)
  col = bId[7..9].to_i(2)
  return row, col, row * 8 + col
end

min_id = 128*8 # max seat + 1 with 128 rows
max_id = 0
sum = 0
File.readlines("5-seats.txt", chomp: true).each do |seat|
  row, col, id = convert_id(seat)
  # puts "%s %d: %d, %d" % [seat, id, row, col]
  max_id = [max_id, id].max
  min_id = [min_id, id].min
  sum += id
end
sum_to_max = max_id*(max_id+1)/2
sum_before_min = (min_id-1)*(min_id)/2
puts "min:%d max:%d missing:%d" % [min_id, max_id, sum_to_max-sum_before_min-sum]
