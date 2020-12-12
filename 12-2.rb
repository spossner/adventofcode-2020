class Ship
  def initialize(x, y)
    @position = [0, 0]
    @waypoint = [x, y]
  end

  def north(steps)
    @waypoint[1] += steps
  end

  def south(steps)
    @waypoint[1] -= steps
  end

  def west(steps)
    @waypoint[0] -= steps
  end

  def east(steps)
    @waypoint[0] += steps
  end

  def left(degree)
    (degree/90).times do
      @waypoint = [-@waypoint[1], @waypoint[0]]
    end
  end

  def right(degree)
    (degree/90).times do
      @waypoint = [@waypoint[1], -@waypoint[0]]
    end
  end

  def forward(steps)
    @position[0] += steps*@waypoint[0]
    @position[1] += steps*@waypoint[1]
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
    "#{@position} with waypoint #{@waypoint} has distance #{manhattan_distance}"
  end
end

commands = File.readlines('12-data.txt', chomp: true)
s = Ship.new(10,1)
commands.each { |cmd| s.execute(cmd) }