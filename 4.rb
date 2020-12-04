def check_passport(p)
  # just simple check for part 1
  return true if p.length == 8
  return true if p.length == 7 && !p.has_key?('cid')
  false
end

def passport_valid?(p)
  return false if !check_passport(p)

  # more check for part 2 :-p
  if /^\d{4}$/.match?(p['byr']) &&
      /^\d{4}$/.match?(p['iyr']) &&
      /^\d{4}$/.match?(p['eyr']) &&
      /\d+[cm|in]/.match?(p['hgt']) &&
      /^#[0-9a-f]{6}$/.match?(p['hcl']) &&
      /^\d{9}$/.match(p['pid']) &&
      /amb|blu|brn|gry|grn|hzl|oth/.match(p['ecl'])

    byr = p['byr'].to_i
    return false if byr < 1920 || byr > 2002
    iyr = p['iyr'].to_i
    return false if iyr < 2010 || iyr > 2020
    eyr = p['eyr'].to_i
    return false if eyr < 2020 || eyr > 2030

    hgt = p['hgt'][0...-2].to_i
    hgt_unit = p['hgt'][-2..-1]
    return false if hgt_unit == "cm" && (hgt < 150 || hgt > 193)
    return false if hgt_unit == "in" && (hgt < 59 || hgt > 76)
    return true # valid - passed all checks
  end
  false # syntax error - did not pass regexp
end


def check_passports()
  count = 0
  passport = Hash.new
  File.readlines("4-passports.txt", chomp: true).each do |line|
    if line.empty?
      count += 1 if passport_valid?(passport)
      passport.clear
    else
      line.split(' ').each do |pair|
        p = pair.split(':')
        passport[p[0]] = p[1]
      end
    end
  end
  count += 1 if passport_valid?(passport)
  return count
end

puts check_passports()