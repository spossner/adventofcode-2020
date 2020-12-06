require 'set'

def check_answers()
  sum = 0
  answers = nil
  File.readlines("6-data.txt", chomp: true).each do |a|
    if a.empty?
      sum += answers.length
      answers = nil
    else
      if answers == nil
        answers = Set.new(a.chars)
      elsif !answers.empty?
        answers = answers & a.chars
      end
    end
  end
  return sum+answers.length
end

puts check_answers
