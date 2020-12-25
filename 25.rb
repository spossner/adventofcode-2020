data = [2959251, 4542595]
#data = [5764801, 17807724]
loop_size = [0, 0]
p = 7
m = 20201227
dp = [1]
pk = 1
i = 0
while loop_size[0] == 0 || loop_size[1] == 0
  pk = (pk * p) % m
  dp << pk
  i += 1
  loop_size[0] = i if loop_size[0].zero? && data[0] == pk
  loop_size[1] = i if loop_size[1].zero? && data[1] == pk
end
puts loop_size.join(',')

ek = 1
loop_size[0].times do
  ek = (ek * data[1]) % m
end
puts ek

