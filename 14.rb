data = File.readlines('14-data.txt', chomp: true)

mem = Hash.new
and_mask = 2.pow(36) - 1
or_mask = 0
puts and_mask.to_s(2)
data.each do |line|
  if line[0..3] == 'mask'
    a = '111111111111111111111111111111111111' # 36 bit 1s mask
    o = '000000000000000000000000000000000000' # 36 bit 0s mask
    line[7..-1].chars.each_with_index do |c, i|
      next if c == 'X'
      if c == '0'
        a[i] = '0'
      elsif c == '1'
        o[i] = '1'
      else
        raise "wrong bitmask value #{c} at #{i} in #{line[7..-1]}"
      end
    end
    and_mask = a.to_i(2)
    or_mask = o.to_i(2)
    puts "new masks #{and_mask} and #{or_mask}"
  else
    /mem\[(\d+)\] = (\d+)/.match(line) do |m|
      value = m.captures[1].to_i & and_mask | or_mask
      address = m.captures[0].to_i
      mem[address] = value
    end
  end
end

puts mem.values.inject(0, :+)