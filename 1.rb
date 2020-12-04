def expense_fix(arr, target)
  candidates = Hash.new
  arr.each_with_index do |e, i|
    complement = target - e
    if candidates.has_key? complement
      return e * complement
    end
    candidates[e] = i
  end
  return -1
end
