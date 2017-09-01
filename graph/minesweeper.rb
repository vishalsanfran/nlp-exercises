require 'set'
class Board
  attr_accessor :array2d
  def initialize(array2d)
    @array2d = array2d
  end
  def get_moves_mines(row, col)
    moves = []
    mines = 0
    (-1..1).to_a.each do |roff|
      n_row = row + roff
      if n_row < 0 or n_row > @array2d.length-1
        next
      end
      (-1..1).to_a.each do |coff|
        n_col = col + coff
        if n_col < 0 or n_col > @array2d[0].length-1 or
           (coff == 0 and roff == 0)
          next
        end
        moves.push({row: n_row, col: n_col})
        if @array2d[n_row][n_col] == 'M'
          mines += 1
        end
      end
    end
    {moves: moves, mines: mines}
  end

  def play_dfs(row, col)
    visited = Set.new
    dfs_helper(row, col, visited)
  end

  def dfs_helper(row, col, visited)
    #puts "row #{row} #{col} init: #{@array2d[row][col]}"
    if visited.include?({row: row, col: col})
      return
    end
    visited.add({row: row, col: col})
    if @array2d[row][col] == 'M'
      @array2d[row][col] = 'X'
      return
    end
    h = get_moves_mines(row, col)
    if h[:mines] != 0
      @array2d[row][col] = h[:mines].to_s
      return
    else
      @array2d[row][col] = "B"
      h[:moves].each do |move|
        dfs_helper(move[:row], move[:col], visited)
      end
    end
  end
end

arry = [['E', 'E', 'E', 'E', 'E'],
 ['E', 'E', 'M', 'E', 'E'],
 ['E', 'E', 'E', 'E', 'E'],
 ['E', 'E', 'M', 'E', 'E']]

b = Board.new(arry)
b.play_dfs(3, 0)
puts b.array2d.inspect
b.play_dfs(1, 2)
puts b.array2d.inspect
