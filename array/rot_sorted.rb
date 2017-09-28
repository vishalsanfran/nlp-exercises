def find(t, nums)
  helper(t, nums, 0, nums.length-1)
end

def helper(t, nums, st, last)
  if last-st == 0
    return false
  end
  if last-st == 1
    return nums[0] == t
  end
  if last-st == 2
    return nums[0] == t || nums[1] == t
  end

  m = (st + last)/2
  #puts "st #{st} m #{m} l #{last}"
  #sleep(2)
  if nums[m] == t
    return true
  end
  if ((t < nums[m] && nums[st] <= t ) || (t > nums[m] && t > nums[last]))
    #puts "here"
    res = helper(t, nums, st, m-1)
  else
    res = helper(t, nums, m+1, last)
  end

  return res
end

puts find(9, [4, 5, 5, 6, 7, 0, 1, 2])
