class Board
  attr_accessor :array2d
  def initialize(row, col, winlen)
    @array2d = Array.new(row){Array.new(col)}
    @winlen = winlen
  end
  def show
    @array2d.each do |row|
      puts row.inspect
    end
  end
  def someone_win?
    return won_row? || won_col? || won_diag? || won_antidiag?
  end
  def won_row?
    #puts "checking row"
    (0..@array2d.length-1).to_a.each do |row|
      st = 0
      fin = 1
      cnt = 0
      while fin < @array2d.length
        if @array2d[row][st] == @array2d[row][fin] && @array2d[row][fin] != nil
          if cnt == 0
            cnt = 2
          else
            cnt += 1
          end
          if cnt == @winlen
            return true
          end
        else
          st = fin
          cnt = 0
        end
        fin += 1
      end
    end
    return false
  end
  def won_col?
    #puts "checking col"
    (0..@array2d[0].length-1).to_a.each do |col|
      st = 0
      fin = 1
      cnt = 0
      while fin < @array2d[0].length
        if @array2d[st][col] == @array2d[fin][col] && @array2d[fin][col] != nil
          if cnt == 0
            cnt = 2
          else
            cnt += 1
          end
          if cnt == @winlen
            return true
          end
        else
          st = fin
          cnt = 0
        end
        fin += 1
      end
    end
    return false
  end
  def won_diag?
    #puts "checking diag"
    (0..@array2d.length-1).to_a.each do |row_idx|
      res = won_diag_rowcol?(row_idx, 0)
      if res == true
        return res
      end
    end
    (1..@array2d[0].length-1).to_a.each do |col_idx|
      res = won_diag_rowcol?(0, col_idx)
      if res == true
        return res
      end
    end
    return false
  end
  def won_antidiag?
    #puts "checking antidiag"
    (0..@array2d.length-1).to_a.each do |row_idx|
      res = won_antidiag_rowcol?(row_idx, 0)
      if res == true
        return res
      end
    end
    (1..@array2d[0].length-1).to_a.each do |col_idx|
      res = won_antidiag_rowcol?(@array2d.length-1, col_idx)
      if res == true
        return res
      end
    end
    return false
  end
  def won_diag_rowcol?(row_st, col_st)
    st = 0
    fin = 1
    cnt = 0
    while col_st+fin < @array2d[row_st].length && row_st+fin < @array2d.length
      if @array2d[row_st+st][col_st+st] == @array2d[row_st+fin][col_st+fin] &&
         @array2d[row_st+fin][col_st+fin] != nil
        if cnt == 0
          cnt = 2
        else
          cnt += 1
        end
        if cnt == @winlen
          return true
        end
      else
        st = fin
        cnt = 0
      end
      fin += 1
    end
    return false
  end
  def won_antidiag_rowcol?(row_st, col_st)
    st = 0
    fin = 1
    cnt = 0
    while col_st+fin < @array2d[row_st].length && row_st-fin > -1
      if @array2d[row_st-st][col_st+st] == @array2d[row_st-fin][col_st+fin] &&
        @array2d[row_st-fin][col_st+fin] != nil
        if cnt == 0
          cnt = 2
        else
          cnt += 1
        end
        if cnt == @winlen
          return true
        end
      else
        st = fin
        cnt = 0
      end
      fin += 1
    end
    return false
  end
end

class GameRunner
  def initialize(board)
    @board = board
  end
  def play(val)
    puts "player #{val} enter row and col"
    row = gets.to_i
    col = gets.to_i
    if row >= @board.array2d.length or col >= @board.array2d[0].length
      raise Exception, "Out of Index"
    end
    if @board.array2d[row][col] != nil
      raise Exception, "Already occupied"
    end
    @board.array2d[row][col] = val
  end
  def two_player
    cnt = 0
    size = @board.array2d.length*@board.array2d[0].length
    puts size
    while cnt < size
      player = cnt%2
      play(player)
      @board.show
      if @board.someone_win?
        puts "player #{player} won!"
        break
      end
      cnt += 1
    end
  end
end

#brd = Board.new(4,4,3)
#brd.array2d = [ [0,1,0,0],
#                [1,1,0,1],
#                [0,0,1,1],
#                [1,2,2,0] ]
#puts brd.someone_win?.inspect
brd = Board.new(4,4,3)
gm = GameRunner.new(brd)
#gm.two_player
