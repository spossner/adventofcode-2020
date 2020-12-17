class Point
  attr_accessor :coord
  def initialize(x=0, y=0, z=0)
    @coord = [x, y, z]
  end

  def x
    @coord[0]
  end

  def y
    @coord[1]
  end

  def z
    @coord[2]
  end

  def eql?(other)
    self == other
  end

  def ==(other)
    @coord == other.coord
  end

  def hash
    @coord.hash
  end

  def to_s
    @coord.to_s
  end
end

class Cube
  attr_accessor :cube, :boundaries
  def initialize(data)
    @cube = Hash.new(0)

    # assuming full extent in data
    @boundaries = {
      x: [0, data[0].length - 1],
      y: [0, data.length - 1],
      z: [0, 0]
    }

    data.each_with_index do |row, y|
      row.chars.each_with_index do |c, x|
        @cube[Point.new(x, y)] = (c == '#' ? 1 : 0)
      end
    end
  end

  def adjacent(coord)
    total = 0
    (-1..1).each do |dz|
      (-1..1).each do |dy|
        (-1..1).each do |dx|
          next if dx == 0 && dy == 0 && dz == 0
          total += @cube[Point.new(coord.x + dx, coord.y + dy, coord.z + dz)]
        end
      end
    end
    total
  end

  def simulate
    new_cube = Hash.new(0)
    new_boundaries = {
      x: [0, 0],
      y: [0, 0],
      z: [0, 0]
    }
    total_active = 0
    (@boundaries[:z][0] - 1..@boundaries[:z][1] + 1).each do |z|
      (@boundaries[:y][0] - 1..@boundaries[:y][1] + 1).each do |y|
        (@boundaries[:x][0] - 1..@boundaries[:x][1] + 1).each do |x|
          coord = Point.new(x, y, z)
          adj = adjacent(coord)
          v = if @cube[coord] == 1
                (adj >= 2 && adj <= 3 ? 1 : 0)
              else
                (adj == 3 ? 1 : 0)
              end
          new_cube[coord] = v
          if v == 1
            total_active += 1
            new_boundaries[:x][0] = [x, new_boundaries[:x][0]].min
            new_boundaries[:x][1] = [x, new_boundaries[:x][1]].max
            new_boundaries[:y][0] = [y, new_boundaries[:y][0]].min
            new_boundaries[:y][1] = [y, new_boundaries[:y][1]].max
            new_boundaries[:z][0] = [z, new_boundaries[:z][0]].min
            new_boundaries[:z][1] = [z, new_boundaries[:z][1]].max
          end
        end
      end
    end
    @cube = new_cube
    @boundaries = new_boundaries
    total_active
  end

  def dump
    (@boundaries[:z][0]..@boundaries[:z][1]).each do |z|
      puts "z=#{z}"
      (@boundaries[:y][0]..@boundaries[:y][1]).each do |y|
        (@boundaries[:x][0]..@boundaries[:x][1]).each do |x|
          print @cube[Point.new(x,y,z)] == 0 ? '.' : '#'
        end
        puts
      end
      puts
    end
  end
end

cube = Cube.new(File.readlines('17-data.txt', chomp: true))
6.times do |i|
  puts "#{i+1}: #{cube.simulate}"
  # cube.dump
end