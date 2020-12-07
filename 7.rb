class Bag
  attr_accessor :name, :contains
  def initialize(bag_name)
    @name = bag_name
    @contains = Hash.new
  end

  def add_contains(bag, qty)
    @contains[bag.name] = qty
  end

  def include?(bag_name)
    @contains.include?(bag_name)
  end
end

class BagRules
  def initialize
    @bags = Hash.new { |hash, bag_name| hash[bag_name] = Bag.new(bag_name) }
  end

  def get_bag(bag_name)
    @bags[bag_name]
  end

  def add_rule(rule_description)
    m = /(.+)\s+bag[s]?\scontain\s+(.+)\./.match(rule_description)
    contains = m[2].split(",").map! { |e| e.strip }
    bag = @bags[m[1]] # creates a bag if not created yet - see initialize
    contains.each do |b|
      /^(\d+) (.+) bag[s]?$/.match(b) do |r|
        sub_bag = @bags[r[2]]
        bag.add_contains(sub_bag, r[1].to_i)
      end
    end
  end

  def find_bags_that_fit(bag_name)
    direct = @bags.select { |_, bag| bag.include?(bag_name) }.keys
    direct | direct.flat_map { |name| find_bags_that_fit(name) }
  end

  def count_bags_in(bag_name)
    get_bag(bag_name).contains.sum do |bag|
      bag[1] + bag[1] * count_bags_in(bag[0]) # qty + qty x the number of bags in the sub-bag
    end
  end
end

bag_rules = BagRules.new
File.readlines("7-data.txt", chomp: true).each do |rule|
  bag_rules.add_rule(rule)
end
puts bag_rules.find_bags_that_fit("shiny gold").length
puts bag_rules.count_bags_in("shiny gold")