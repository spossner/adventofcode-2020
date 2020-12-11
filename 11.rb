def adjacent(state, i, j)
  adjacent_count = 0
  (-1..1).each do |dy|
    k = i+dy
    next if k < 0 || k >= state.length
    (-1..1).each do |dx|
      next if dy == 0 && dx == 0
      l = j+dx
      next if l < 0 || l >= state[k].length
      adjacent_count += 1 if state[k][l] == '#'
    end
  end
  adjacent_count
end

def visible_occupied_seats(state, i, j)
  adjacent_count = 0
  (-1..1).each do |dy|
    (-1..1).each do |dx|
      next if dy == 0 && dx == 0
      k, l = i, j
      loop do
        k += dy
        l += dx
        break if k < 0 || k >= state.length || l < 0 || l >= state[k].length
        next if state[k][l] == '.'
        adjacent_count += 1 if state[k][l] == '#'
        break
      end
    end
  end
  adjacent_count
end


state = File.readlines('11-test.txt', chomp: true)

state_changed = true
while state_changed do
  # puts state
  new_state = []
  state_changed = false
  state.length.times do |i|
    row = state[i]
    new_row = ""
    row.length.times do |j|
      if row[j] == '.'
        new_row << '.'
      else
        adjecent_count = visible_occupied_seats(state, i, j)
        if row[j] == 'L' and adjecent_count == 0
          new_row << '#'
          state_changed = true
        elsif row[j] == '#' and adjecent_count >= 5 # 5 in part two; was 4 in part 1
          new_row << 'L'
          state_changed = true
        else
          new_row << row[j]
        end
      end
    end
    new_state << new_row
  end
  state = new_state
end

puts state.reduce(0) { |sum, row| sum + row.count('#') }