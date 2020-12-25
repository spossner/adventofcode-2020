require 'set'
def check(s)
  return false if (s[4] != '5' && s[4] != '0') || s[9] != '0' # 5 and 10
  return false if s[1].to_i.odd? || s[3].to_i.odd? || s[5].to_i.odd? || s[7].to_i.odd? # odd digit can not make
  digits = Set.new(s.split(''))
  return false if s[0..2].to_i % 3 != 0
  return false if s[0..5].to_i % 3 != 0
  return false if s[2..3].to_i % 4 != 0
  return false if s[5..7].to_i % 8 != 0
  return false if s[0..6].to_i % 7 != 0
  # all digits are 45 in sum.. always dividable by 9
  return false if digits.length < 10 # we need all digits
  return true
end

# (123456789..9876543210).each do |no|
#   print '.' if no % 100000 == 0
#   print "\r[#{no}]" if no % 1000000 == 0
#   puts "\r#{no}\n" if check(no)
# end
[0,1,2,3,4,5,6,7,8,9].permutation.each_with_index do |digits, i|
  no = digits.join('')
  print '.' if i % 100000 == 0
  print "\r[#{no}]" if i % 1000000 == 0
  puts "\r#{no}\n" if check(no)
end
