require 'set'

class ExecutionError < StandardError
  attr_accessor :exception_type
  def initialize(msg= 'SYNTAX ERROR', exception_type= 'RUNTIME')
    @exception_type = exception_type
    super(msg)
  end
end

def run(code)
  acc = 0
  ptr = 0
  visited = Set.new

  loop do
    return acc if ptr == code.length
    if ptr < 0 || ptr > code.length
      raise ExecutionError.new("line #{ptr} with acc #{acc}", '?UNDEF\'D STATEMENT ERROR')
    end
    if visited.add?(ptr) == nil
      raise ExecutionError.new("line #{ptr} with acc #{acc}", '?INFINITE LOOP')
    end
    op = code[ptr]
    case op[0]
    when 'acc'
      acc += op[1]
      ptr += 1
    when 'jmp'
      ptr += op[1]
    else
      ptr += 1
    end
  end
end

code = File.readlines('8-fixed.txt', chomp: true).map do |row|
  m = row.match(/(\w+) ([0-9+-]+)/).captures
  [m[0], m[1].to_i]
end

# PART 1
begin
  puts run(code)
rescue ExecutionError => e
  puts "#{e.exception_type}: #{e.message}"
end

# PART 2
code.length.times do |i|
  back = code[i]

  case code[i][0]
  when 'jmp'
    code[i] = ['nop', code[i][1]]
  when 'nop'
    code[i] = ['jmp', code[i][1]]
  else
    next
  end

  begin
    puts run(code)
    break
  rescue ExecutionError => e
    puts "#{e.exception_type}: #{e.message}"
  end

  code[i] = back
end
