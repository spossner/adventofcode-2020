def password_check
  lines = File.readlines("2-input.txt")
  hits = 0
  lines.each do |line|
    /(\d+)-(\d+)\s+(\w):\s+(\S+)/.match(line) do |m|
      c = m.captures[3].count(m.captures[2])
      hits = hits + 1 if c >= m.captures[0].to_i && c <= m.captures[1].to_i
    end
  end
  return hits
end

def password_check_simple
  lines = File.readlines("2-input.txt")
  hits = 0
  lines.each do |line|
    /(\d+)-(\d+)\s+(\w):\s+(\S+)/.match(line) do |m|
      s = m.captures[3]
      c = m.captures[2]
      hits = hits + 1 if (s[m.captures[0].to_i-1] == c and s[m.captures[1].to_i-1] != c) || (s[m.captures[0].to_i-1] != c && s[m.captures[1].to_i-1] == c)
    end
  end
  return hits
end


puts password_check
puts password_check_simple