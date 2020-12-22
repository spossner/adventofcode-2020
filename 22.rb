decks = File.read('22-input.txt', chomp: true)
            .split("\n\n")
            .map { |s| s.split("\n")  }
            .map { |d| d.filter_map { |l| l.to_i if l[0] != 'P' } }
puts decks.to_s

round = 0
until decks.any?(&:empty?)
  round += 1
  puts "-- Round #{round} --"
  puts "Player 1's deck: #{decks[0]}"
  puts "Player 2's deck: #{decks[1]}"
  p1 = decks[0].shift
  p2 = decks[1].shift
  puts "Player 1 plays: #{p1}"
  puts "Player 2 plays: #{p2}"

  case p1 <=> p2
  when -1
    puts "Player 2 wins round!"
    decks[1] += [p2, p1]
  when 1
    puts "Player 1 wins round!"
    decks[0] += [p1, p2]
  else
    decks[0] += p1
    decks[1] += p2
  end

end

puts "== Post-game results =="
puts "Player 1's deck: #{decks[0]}"
puts "Player 2's deck: #{decks[1]}"

scores = decks.map do |d|
  d.reverse
   .each_with_index
   .reduce(0) { |memo, (card, i)| memo + card * (i+1) }
end
score = scores.max

puts score