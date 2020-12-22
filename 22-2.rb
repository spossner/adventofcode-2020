require 'set'

decks = File.read('22-input.txt', chomp: true)
            .split("\n\n")
            .map { |s| s.split("\n")  }
            .map { |d| d.filter_map { |l| l.to_i if l[0] != 'P' } }
puts decks.to_s
$game_count = 1
def play(decks)
  found = Set.new
  game = $game_count
  $game_count += 1
  round = 0

  puts "=== Game #{game} ===\n"
  until decks.any?(&:empty?)
    round += 1
    puts "-- Round #{round} (Game #{game}) --"
    puts "Player 1's deck: #{decks[0]}"
    puts "Player 2's deck: #{decks[1]}"

    if found.include?([decks[0], decks[1]])
      puts "INFINITE GAME -> p1 wins"
      return 1
    end
    found << [decks[0].dup, decks[1].dup]

    p1 = decks[0].shift
    p2 = decks[1].shift
    puts "Player 1 plays: #{p1}"
    puts "Player 2 plays: #{p2}"

    if p1 <= decks[0].length && p2 <= decks[1].length
      puts "Playing a sub-game to determine the winner...\n"
      winner = play([decks[0][0..p1-1], decks[1][0..p2-1]])
    else
      if p1 > p2
        winner = 1
      else
        winner = 2
      end
    end
    if winner == 1
      puts "Player 1 wins round #{round} of game #{game}!\n"
      decks[0] << p1
      decks[0] << p2
    else
      puts "Player 2 wins round #{round} of game #{game}!\n"
      decks[1] << p2
      decks[1] << p1
    end
  end
  decks[0].empty? ? 2 : 1
end

winner = play(decks)

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