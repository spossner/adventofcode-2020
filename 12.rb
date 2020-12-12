class Ship
  def initialize()
    @direction = [1, 0]
    @position = [0, 0]
  end

  def north(steps)
    @position[1] += steps
  end

  def south(steps)
    @position[1] -= steps
  end

  def west(steps)
    @position[0] -= steps
  end

  def east(steps)
    @position[0] += steps
  end

  def left(degree)
    (degree/90).times do
      @direction = [-@direction[1], @direction[0]]
    end
  end

  def right(degree)
    (degree/90).times do
      @direction = [@direction[1], -@direction[0]]
    end
  end

  def forward(steps)
    @position[0] += steps*@direction[0]
    @position[1] += steps*@direction[1]
  end

  def execute(cmd)
    op = cmd[0]
    value = cmd[1..-1].to_i
    case op
    when 'N'
      north(value)
    when 'S'
      south(value)
    when 'E'
      east(value)
    when 'W'
      west(value)
    when 'L'
      left(value)
    when 'R'
      right(value)
    when 'F'
      forward(value)
    end
    puts to_s
  end

  def manhattan_distance()
    (@position[0]).abs + (@position[1]).abs
  end

  def to_s
    "#{@position} facing #{@direction} with distance #{manhattan_distance}"
  end
end

commands = File.readlines('12-data.txt', chomp: true)
s = Ship.new
commands.each { |cmd| s.execute(cmd) }