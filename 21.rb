data = File.readlines('21-input.txt', chomp: true)

table = Hash.new
found = Hash.new
count = Hash.new(0)
data.each do |row|
  row.match(/(.*)\s*\(contains ([^)]+)\)/) do |m|
    ingredients = m[1].split(' ')
    ingredients.each { |ing| count[ing] += 1 }
    allergens = m[2].split(',').map { |s| s.strip }
    allergens.each do |a|
      if table.key?(a) # already found a list
        table[a] = table[a] & ingredients
        raise "NO INGREDIENT LEFT FOR #{a}" if table[a].empty?
      else
        table[a] = ingredients
      end

      if table[a].length == 1
        deque = [a]

        until deque.empty?
          deque.length.times do
            _a = deque.shift
            found[_a] = table[_a].first
            table.each do |k, v|
              next if k == _a
              deleted = v.delete(found[_a]) # delete unique match from other entries
              deque << k if deleted != nil && v.length == 1 # new single mapping
            end
          end
        end

      end
    end
  end
end
no_match = count.keys - found.values
puts "PART 1: #{no_match.reduce(0) { |sum, m| sum + count[m]}}"

puts "PART 2: #{found.keys.sort.map { |_a| found[_a] }.join(',')}"
