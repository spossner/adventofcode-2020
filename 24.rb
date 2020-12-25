require 'set'
grid = Hash.new(0) # [q,r] => color with 0 = white; 1 = black
data = File.readlines('24-input.txt', chomp: true)

data.each do |row|
  ptr = [0, 0]
  dr = 0
  row.each_char do |c|
    case c
    when 'n'
      dr = -1
    when 's'
      dr = 1
    when 'e'
      ptr[0] += 1 if dr <= 0
      ptr[1] += dr
      dr = 0
    when 'w'
      ptr[0] -= 1 if dr >= 0
      ptr[1] += dr
      dr = 0
    end
  end
  v = grid[ptr]
  if v == 0
    grid[ptr] = 1 # flip grid[ptr]
  else
    grid.delete(ptr) # delete white tiles
  end
end
puts "Part 1: #{grid.length}"

DIRECTIONS = [
  [1,0], [1, -1], [0, -1], [-1, 0], [-1, +1], [0, +1],
]

def all_neighbours(ptr)
  DIRECTIONS.map { |offset| [ptr[0]+offset[0], ptr[1]+offset[1]] }
end

def count_black_neighbour_tiles(grid, ptr)
  DIRECTIONS.reduce(0) { |sum, offset| sum + grid[[ptr[0] + offset[0], ptr[1] + offset[1]]] }
end

100.times do |day|
  to_check = Set.new(grid.keys)
  grid.each_key do |ptr|
    to_check.merge(all_neighbours(ptr))
  end

  new_grid = Hash.new(0)
  to_check.each do |ptr|
    black_tiles = count_black_neighbour_tiles(grid, ptr)
    if grid[ptr] == 1
      new_grid[ptr] = 1 if black_tiles == 1 || black_tiles == 2
    else
      new_grid[ptr] = 1 if black_tiles == 2
    end
  end
  grid = new_grid

  puts "Day #{day+1}: #{grid.length}"
end