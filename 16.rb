class TicketRule
  attr_accessor :name
  def initialize(name, r1, r2)
    @name = name
    @r1 = r1
    @r2 = r2
  end

  def departure?()
    @name.include?('departure')
  end

  def valid?(n)
    (n >= @r1[0] && n <= @r1[1]) || (n >= @r2[0] && n <= @r2[1])
  end

  def TicketRule.from_s(s)
    /^([^:]+): (\d+)-(\d+) or (\d+)-(\d+)$/.match(s) do |m|
      values = m.captures
      return TicketRule.new(values[0], [values[1].to_i, values[2].to_i], [values[3].to_i, values[4].to_i])
    end
    raise "SYNTAX ERROR: #{s}"
  end

  def to_s
    "#{@name}: #{@r1} or #{@r2}"
  end
end

data = File.readlines('16-data.txt', chomp: true)
rules = []
i = 0
until data[i].empty?
  rules << TicketRule.from_s(data[i])
  i = i + 1
end

i += 2 # skip your ticket label
my_ticket = data[i].split(',').map { |s| s.to_i }

i += 3 # skip empty line and nearby tickets label
tickets = data[i..-1].map { |row| row.split(',').map { |s| s.to_i } }

total = 0
valid_tickets = []
tickets.each_with_index do |ticket, i|
  valid = true
  ticket.each do |v|
    if not rules.any? { |r| r.valid?(v) }
      total += v
      valid = false # still process all values in case of multiple wrong numbers to solve part 1
    end
  end
  valid_tickets << ticket if valid
end
puts "Part 1: #{total}"

candidates = []
# prefill rules with first ticket
valid_tickets[0].each_with_index do |n, i|
  candidates << rules.filter_map { |r| r if r.valid?(n) }
end

# reduce rules per field with the other tickets
valid_tickets[1..-1].each do |ticket|
  ticket.each_with_index do |n, i|
    field_rules = candidates[i] # potential rules for the field #i
    next if field_rules.length == 1
    field_rules = field_rules.filter_map { |r| r if r.valid?(n) } # filter to only valid rules
    candidates[i] = field_rules
    if field_rules.length == 1 # found single rule for #i
      deque = [[field_rules[0],i]]
      until deque.empty?
        deque.length.times do
          rule_pair = deque.shift # remove rule from all other candidates now
          rule = rule_pair[0]
          rule_origin = rule_pair[1]

          candidates.each_with_index do |arr, j|
            next if j == rule_origin || arr.length == 1 # do not remove the single rule in the candidate we worked on
            arr.delete(rule)
            if arr.length == 1
              deque << [arr[0], j]
            end
          end
        end
      end
    end
  end
end

total = 1
candidates.each_with_index do |r, i|
  if r[0].departure?
    total = total * my_ticket[i]
  end
end
puts "Part 2: #{total}"