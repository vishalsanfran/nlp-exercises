islands = [
  [1,1,0,0,0]
  [1,1,0,0,0],
  [0,0,1,0,0],
  [0,0,0,1,1]
]

class UnionRank
  def initialize(val)
    @val = val
    @ranks = Array.new(val.length){Array.new(val[0].length, 1)}
    @roots = Array.new(val.length){Array.new(val[0].length)}
  end

end
