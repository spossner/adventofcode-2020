require 'set'
class Image
  attr_accessor :id, :rows
  def initialize(id, rows)
    @id = id
    @rows = rows
  end

  def get_edges
    edges = Hash.new
    edges[@rows[0]] = "N"
    edges[@rows[0].reverse] = "N_H"
    edges[@rows[-1]] = "S"
    edges[@rows[-1].reverse] = "S_H"
    l, r = "", ""
    @rows.each do |row|
      l.concat(row[0])
      r.concat(row[-1])
    end
    edges[l] = "W"
    edges[l.reverse] = "W_V"
    edges[r] = "E"
    edges[r.reverse] = "E_V"
    edges
  end

  def Image.from_s(s)
    rows = s.split("\n")
    id = rows[0].match(/Tile (\d+):/)[1].to_i
    Image.new(id, rows[1..-1])
  end

  def build_adjacent(others)
    edges = get_edges
    adjacent = Hash.new
    others.each do |other|
      next if self == other
      stitches = edges.keys & other.get_edges.keys
      next if stitches.empty?
      adjacent[other.id] = edges.select { |k, v| v.length == 1 && stitches.include?(k) }
    end
    adjacent
  end

  OPPOSITE = {
    'N' => 'S',
    'S' => 'N',
    'W' => 'E',
    'E' => 'W'
  }

  ROTATIONS = {
    'S' => { 'E_V' => 'rcw', 'E' => 'rcw,fh', 'N' => 'fv', 'S_H' => 'fh', 'W' => 'rcc', 'N_H' => 'fh,fv'},
    'W' => { 'N' => 'rcc,fv', 'E' => 'fh', 'N_H' => 'rcc', 'W_V' => 'fv'},
  }

  # rotates img so that the given edge is at the given direction (in left2right or top2bottom order)
  def rotate(edge, direction)
    edges = get_edges
    current_direction = edges[edge]
    return false if direction == current_direction
    puts "rotate #{id} so that #{edge} is #{direction} - at the moment #{edge} is showing #{current_direction}"
    ROTATIONS[direction][current_direction].split(',').each { |cmd| self.send(cmd) }
    edges = get_edges
    current_direction = edges[edge]
    puts "..rotated #{id} so that #{edge} is now showing #{current_direction}"
    raise "WRONG ROTATION" if direction != current_direction
    return true
  end

  def rotate_opposite(edge, direction)
    rotate(edge, OPPOSITE[direction])
  end

  def rcc
    new_rows = Array.new(@rows[0].size, '')
    @rows.each do |row|
      row.chars.each_with_index do |c, i|
        new_rows[-i-1] += c
      end
    end
    @rows = new_rows
  end

  def rcw
    new_rows = Array.new(@rows[0].size, '')
    @rows.reverse_each do |row|
      row.chars.each_with_index do |c, i|
        new_rows[i] += c
      end
    end
    @rows = new_rows
  end

  def fh
    @rows.each { |row| row.reverse! }
  end

  def fv
    @rows.reverse!
  end

  def shrink()
    @rows = @rows[1..-2].map { |e| e[1..-2] }
  end

  def to_s
    result = "Tile #{@id}\n"
    @rows.each { |r| result << "#{r}\n" }
    result += "\n"
    result
  end

  def ==(other)
    return false if other == nil
    @id == other.id
  end

  def eql?(other)
    self == other
  end
end

def rotate_image(image)
  new_image = Array.new(image[0].size, '')
  image.each do |row|
    row.chars.each_with_index do |c, i|
      new_image[-i-1] += c
    end
  end
  new_image
end

def flip_horizontal(image)
  image.map { |row| row.reverse }
end

def flip_vertical(image)
  image.reverse
end

data = File.read('20-input.txt', chomp: true)
blocks = data.split("\n\n")
tiles = Hash.new
blocks.each do |block|
  img = Image.from_s(block)
  tiles[img.id] = img
end
corners = Hash.new
borders = Hash.new
centers = Hash.new
adjacents = Hash.new

total = 1
tiles.each_entry do |id, tile|
  adjacent = tile.build_adjacent(tiles.values)
  adjacents[id] = adjacent
  case adjacent.length
  when 2
    puts "#{id} #{adjacent}"
    corners[id] = adjacent
    total *= id
  when 3
    borders[id] = adjacent
  else
    centers[id] = adjacent
  end
end
puts "PART 1: #{total}"

grid = Array.new(borders.length/4+2)
grid.length.times do |i|
  grid[i] = Array.new(borders.length/4+2)
end

grid[0][0] = tiles[corners.keys.first]
(0..grid.length-1).each do |y|
  (0..grid.length-1).each do |x|
    tile = grid[y][x]

    tile.build_adjacent(tiles.values).each do |adj|
      puts "extend #{tile.id} by #{adj}"
      a_id = adj[0]
      raise "multiple edges" if adj[1].length > 1
      a_edge = adj[1].to_a.first
      next if a_edge[1] == 'S' || a_edge[1] == 'W'
      next_tile = tiles[a_id]
      rotated = next_tile.rotate_opposite(a_edge[0], a_edge[1])
      if a_edge[1] == 'E'
        raise "ROTATED ALREADY TILE" if rotated && grid[y][x+1] == next_tile
        raise "FOUND ANOTHER TILE #{grid[y][x+1]} at (#{y}, #{x+1})" if grid[y][x+1] != nil && grid[y][x+1] != next_tile
        grid[y][x+1] = next_tile
      end
      grid[y+1][x] = next_tile if a_edge[1] == 'N'
    end
  end
end

grid.each do |row|
  row.each do |t|
    t.shrink
    print "#{t.id}\t"
  end
  puts
end

image = Array.new(grid.length*grid[0][0].rows.length, '')
grid.each_with_index do |block_row, y|
  block_row.each_with_index do |block, x|
    block.rows.reverse.each_with_index do |row, i|
      image[y*block.rows.length+i] += row
    end
  end
end
# puts image

PATTERN = [
  /(?=.{18}#.)/,
  /(?=#....##....##....###)/,
  /(?=.#..#..#..#..#..#...)/,
]

def find_monster(image)
  monster = Hash.new
  (2..image.length-1).each do |y|
    indices = []
    indices << image[y].gsub(PATTERN[2]).map { Regexp.last_match.begin(0) }
    next if indices[0].empty?
    indices << image[y-1].gsub(PATTERN[1]).map { Regexp.last_match.begin(0) }
    next if indices[1].empty?
    indices << image[y-2].gsub(PATTERN[0]).map { Regexp.last_match.begin(0) }
    next if indices[2].empty?
    indices = indices[0] & indices[1] & indices[2]
    next if indices.empty? # not a the same starting offset
    puts "found all parts of seamonster at #{indices}"
    monster[y-2] = indices
  end
  return monster
end

image = rotate_image(image)
# image = flip_vertical(image)
puts image
monster = find_monster(image)

monster_count = monster.values.reduce(0) { |sum,indices| sum + indices.length}
puts image.inject(0) { |memo, e| memo + e.count('#') } - monster_count * 15