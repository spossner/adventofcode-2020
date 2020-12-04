def expense_fix_3(arr, target)
  arr.each_with_index do |f, i|
    t = target - f
    candidates = Hash.new
    arr[i+1..-1].each_with_index do |e, i|
      complement = t - e
      if candidates.has_key? complement
        return f * e * complement
      end
      candidates[e] = i
    end
  end
  return -1
end
