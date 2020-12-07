# frozen_string_literal: true

class RuleSet
  def initialize(lines)
    @rules = lines.map { |l| Rule.new(l) }
  end

  def find_bags_that_fit(bag)
    direct = @rules.select { |r| r.fits?(bag) }.map(&:subject)
    direct | direct.flat_map { |bag| find_bags_that_fit(bag) }
  end

  def count_bags_in(bag)
    rule_for(bag).content_rules.sum do |bag, amount|
      amount + count_bags_in(bag) * amount
    end
  end

  def rule_for(bag)
    @rules.find { |r| r.subject == bag }
  end
end

class Rule
  attr_reader :subject, :content_rules

  def initialize(text)
    @subject, content_rules = text.match(/\A(\w+ \w+) bags contain (.+)\.\z/).captures
    @content_rules = content_rules.split(/,\s/).map do |content_rule|
      next if content_rule == 'no other bags'

      match = content_rule.match(/\A(\d+) (\w+ \w+) bags?\z/)
      [match[2], match[1].to_i]
    end.compact.to_h
  end

  def fits?(bag)
    @content_rules.keys.include?(bag)
  end
end

rule_set = RuleSet.new(File.readlines('./7-data.txt', chomp: true))
p rule_set.find_bags_that_fit('shiny gold').count
p rule_set.count_bags_in('shiny gold')
