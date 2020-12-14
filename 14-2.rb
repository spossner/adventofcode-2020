data = File.readlines('14-data.txt', chomp: true)

mem = Hash.new
and_mask = 2.pow(36)-1
or_mask = 0
xor_masks = [0]
data.each do |line|
  if line[0..3] == 'mask'
    a = '111111111111111111111111111111111111' # 36 bit 1s mask
    o = '000000000000000000000000000000000000' # 36 bit 0s mask
    x = [0]
    line[7..-1].chars.each_with_index do |c, i|
      next if c == '0'
      if c == 'X'
        a[i] = '0'
        x.length.times do |j|
          x << (x[j] | 2.pow(35-i))
        end
      elsif c == '1'
        o[i] = '1'
      else
        raise "wrong bitmask value #{c} at #{i} in #{line[7..-1]}"
      end
    end
    and_mask = a.to_i(2)
    or_mask = o.to_i(2)
    xor_masks = x
    puts "new masks #{and_mask.to_s(2)}, #{or_mask.to_s(2)} and #{xor_masks}"
  else
    /mem\[(\d+)\] = (\d+)/.match(line) do |m|
      value = m.captures[1].to_i
      address = m.captures[0].to_i & and_mask | or_mask
      xor_masks.each do |x|
        mem[address ^ x] = value
      end
    end
  end
end

puts mem.values.inject(0, :+)