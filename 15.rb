# data = [0,3,6]
data = [20,9,11,0,1,2]

reverse = data.reverse
(2020-reverse.length).times do |i|
  turn = i+1
  last_number = reverse[0]
  recent = reverse[1..-1].index(last_number)
  recent = recent == nil ? 0 : recent+1
  puts "#{turn}: #{last_number} found at position #{recent}"
  reverse.unshift(recent)
end
# puts reverse


