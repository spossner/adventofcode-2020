require 'set'

result = Hash.new(0)
data = File.readlines('10-data.txt', chomp: true).map { |s| s.to_i }.sort
data.unshift(0) << data[-1]+3
data[1..-1].each_with_index do |n, i|
  result[n-data[i]] += 1
end
puts "#{result}: r[1] x r[3] = #{result[1]*result[3]}"

v = [] # store all reachable nodes within reach of 3 jolts per node
data[0..-2].each_with_index do |n, i|
  m = n+3 # max = current+3
  childs = [i+1] # next one is always reachable in our test data
  if i < data.length-2 && data[i+2] <= m # +2 reachable?
    childs << i+2
  end
  if i < data.length-3 && data[i+3] <= m # +3 reachable?
    childs << i+3
  end
  v << childs
end
v << [] # add last empty one (nothing reachable from device) to avoid special handling in later loop

dp = Array.new(data.length, 0) # stores the number of possible paths from dp[i] to the end
dp[-1] = 1 # last one is 1

# traverse in reverse order
(data.length-1).downto(0) do |i|
  v[i].each { |j| dp[i] += dp[j] } # sum all possible paths of the reachable nodes
end
puts "with #{dp[0]} possible paths"