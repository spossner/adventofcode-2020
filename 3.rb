def count_trees(dx, dy)
  trees = File.readlines("3-trees.txt", chomp: true)
  width = trees[0].length
  height = trees.length
  x = 0
  y = 0
  count = 0
  while y < height - dy do
    x = (x + dx) % width
    y = y + dy
    count = count + 1 if trees[y][x] == "#"
  end
  return count
end

total = count_trees(1,1)
total *= count_trees(3,1)
total *= count_trees(5,1)
total *= count_trees(7,1)
total *= count_trees(1,2)
puts total