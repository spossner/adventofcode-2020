def brute_force(busses)
  max_i = busses.each_with_index.max[1]
  highest = busses[max_i]
  time = highest
  found = false
  while !found
    found = true
    busses.each_with_index do |id, i|
      next if id == 0
      target = time - (max_i-i)
      if target < 0 || (target % id) != 0
        found = false
        break
      end
    end
    return time-max_i if found # first entry in data must <> 'x'!
    time += highest
  end
end

def mod_inverse(a, m)
  (1..m).each { |x| break x if (a*x % m == 1) }
end

data = File.readlines('13-data.txt', chomp: true)
# data = ["","7,13,x,x,59,x,31,19"]
# data = ["", "17,x,13,19"]
busses = data[1].split(',').map{ |id| id == 'x' ? 0 : id.to_i}
# puts "brute force #{brute_force(busses)}"

product = 1
busses.each do |b|
  product *= b if b != 0
end

total = 0
busses.each_with_index do |n, i|
  if n > 0
    product_without = product / n
    mod_inverse = mod_inverse(product_without, n)
    total = (total + (n - i % n) * product_without * mod_inverse) % product
  end
end
puts "calculated #{total}"

