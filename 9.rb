require 'set'
class XMASParser
  class XMASSet
    def initialize(base, number = nil)
      @base = base
      @numbers = Set.new
      @numbers.add(base+number) if number != nil
    end

    def add(number)
      @numbers.add(@base+number)
    end

    def include?(number)
      @numbers.include?(number)
    end

    def get_number_without_base()
      raise "NOT LAST BUCKET" unless @numbers.size == 1
      @numbers.first - @base
    end
  end

  def initialize(data, size)
    @data = data
    @size = size
    @rolling_window = []
    reset_window()
  end

  def reset_window()
    @rolling_window = []
    start_index = 0
    end_index = start_index+@size-1
    (start_index...end_index).each do |i|
      set = XMASSet.new(@data[i])
      (i+1..end_index).each do |j|
        set.add(@data[j])
      end
      @rolling_window << set
    end
  end

  def include?(number)
    @rolling_window.each do |s|
      return true if s.include?(number)
    end
    false
  end

  def shift_window(number)
    # remove first bucket
    @rolling_window.shift
    # get last bucket number (new base for new bucket)
    last = @rolling_window[-1].get_number_without_base()
    # add number to all existing buckets
    @rolling_window.each { |s| s.add(number) }
    # create new bucket with number + the number before
    @rolling_window << XMASSet.new(last, number)
  end

  def check()
    @data[@size..-1].each_with_index do |n, i|
      if !include?(n)
        return n
      end
      shift_window(n)
    end
  end

  def find_minmax_of_sum(target)
    left, right = 0, 1
    sum = @data[0]

    while sum != target
      if sum < target
        sum += @data[right]
        right += 1
      else
        sum -= @data[left]
        left += 1
      end
      raise "ILLEGAL BOUNDS #{left}, #{right}" unless left < right
    end
    @data[left...right].minmax
  end
end

data = File.readlines('9-data.txt', chomp: true).map { |s| s.to_i }
puts data
parser = XMASParser.new(data, 25)
illegal = parser.check()
puts "min+max of subsequence with sum #{illegal}: #{parser.find_minmax_of_sum(illegal).sum}"