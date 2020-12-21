class Cursor
  attr_accessor :word, :ptr
  def initialize(word)
    @word = word
    @ptr = 0
  end

  def current
    @ptr
  end

  def set(ptr)
    @ptr = ptr
  end

  def finished?
    @ptr >= @word.length
  end

  def match?(c)
    r = (c == @word[@ptr])
    @ptr += 1
    return r
  end

  def to_s
    "#{@word}[#{@ptr}]"
  end
end

class Rule
  def initialize(id, match = nil)
    @id = id
    @match = match
    @subrules = [] # or-connected array of and-connected rules
  end

  def set_match(s)
    raise "RULE HAS SUBRULES" unless @subrules.empty?
    @match = s
  end

  def add_subrules(rules)
    raise "RULE HAS CHARACTER" unless @match == nil
    @subrules << rules
  end

  def match?(cursor)
    return cursor.match?(@match) if @match != nil

    @subrules.each do |rules|
      c = cursor.clone
      matched =  rules.all? do |rule|
        rule.match?(c)
      end
      if matched
        if @id == 8 || @id == 11 # ||@id == 2
          w = cursor.word
          puts "#{@id}\t#{cursor.word}\t#{cursor.word[cursor.ptr..c.ptr]}\t#{cursor.ptr}\t#{c.ptr-1}\t#{c.ptr-cursor.ptr}"
          pattern_len = c.ptr-cursor.ptr
          if w.length >= c.ptr + pattern_len
            puts "..#{cursor.word[c.ptr..c.ptr+pattern_len]}"
          end
        end

        cursor.set(c.current)

        return true
      end
    end
    return false
  end

  def to_s
    "#{@id}: #{@match != nil ? @match : @subrules}"
  end

  def inspect
    "#{@id}"
  end
end

class RuleTree
  def initialize
    @tree = Hash.new
  end

  def get_rule(no)
    if !@tree.key?(no)
      rule = Rule.new(no)
      @tree[no] = rule
      return rule
    end
    @tree[no]
  end

  def match?(word)
    raise "MISSING START RULE" unless @tree.key?(0)
    rule = @tree[0]
    cursor = Cursor.new(word)
    rule.match?(cursor) && cursor.finished?
  end
end

data = File.readlines('19-test3.txt', chomp: true)
tree = RuleTree.new
i = 0
while i < data.length && data[i].length > 0
  data[i].match(/(\d+): (.*)/) do |m|
    no = m.captures[0].to_i
    exp = m.captures[1]
    rule = tree.get_rule(no)
    if exp =~ /"\w+"/
      rule.set_match(exp[1..-2])
    else
      exp.split('|').each do |group|
        rule.add_subrules(group.split(' ').map { |e| tree.get_rule(e.to_i) })
      end
    end
  end
  i += 1
end

total = 0
data[i+1..-1].each do |word|
  if tree.match?(word)
    # puts word
    puts "#{word} MATCHED"
    total += 1
  else
    #puts "FAILED #{word}, #{word.length}, #{word.length-24} - 11 or 16?"
    # puts "#{word} FALSE"
  end
end
puts total


