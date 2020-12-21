class Parser
  # NOTE the weird precedence in puzzle
  PRECEDENCE = {
    '^' => 1,
    '*' => 1, # * second!
    '/' => 1,
    '+' => 2, # + first!
    '-' => 2
  }.freeze

  def initialize(exp)
    @rpn = []

    operators = []
    pieces = exp.scan(/\d+|[\^*\/)(+-]/)
    pieces.each do |x|
      if x =~ /\d/
        @rpn << x
      elsif x == '('
        operators << x
      elsif x == ')'
        while !operators.empty? &&  operators.last != '(' # searching the left parenthesis
          @rpn << operators.pop
        end
        raise "MISSING OPENING PARENTHESIS in #{exp}" if operators.empty?
        operators.pop # pop the left parenthesis from stack
      else
        while !operators.empty? && operators.last != '(' && PRECEDENCE[operators.last] >= PRECEDENCE[x]
          @rpn << operators.pop
        end
        operators << x
      end
    end
    @rpn += operators.reverse # pop rest of operators to output queue in reverse order
  end
  
  def calculate
    puts @rpn.to_s
    @rpn.each_with_object([]) do |token, stack|
      if !PRECEDENCE[token]
        stack << token
      else
        v1, v2 = stack.pop(2)
        stack << eval("#{v1}#{token}#{v2}")
      end
    end.first
  end
end

data = File.readlines('18-test.txt', chomp: true)
sum = 0
data.each do |s|
  result = Parser.new(s).calculate
  puts result
  sum += result
end
puts sum