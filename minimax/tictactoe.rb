class Board
  attr_accessor :array2d, :winlen
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
  def get_empty
    res = []
    (0..@array2d.length-1).to_a.each do |row|
      (0..@array2d[0].length-1).to_a.each do |col|
        if @array2d[row][col] == nil
          res.push([row, col])
        end
      end
    end
    return res
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
    @maxdepth = 6
    @board.show
  end
  def play(val)
    puts "player #{val} enter row and col (nil entries are available)"
    print "Row: "
    row = gets.to_i
    print "Column: "
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
  def one_player
    puts "Playing vs Computer, Match #{@board.winlen} tiles to win! "
    cnt = 0
    size = @board.array2d.length*@board.array2d[0].length
    while cnt < size
      player = cnt%2
      if player == 0
        play(player)
      else
        puts "Computer is thinking..."
        res = next_ai_move
        row = res[0]
        col = res[1]
        puts "AI plays #{res.inspect}"
        @board.array2d[row][col] = 1
      end
      @board.show
      if @board.someone_win?
        winner = player == 0 ? "You" : "Sorry, Computer"
        puts "#{winner} won!"
        break
      end
      cnt += 1
    end
  end
  def minimax(depth, player)
    moves = @board.get_empty
    if moves.length == 0
      return 0
    end
    score = eval_func(player, depth)
    puts "score #{score}"
    if depth == 0 or score == 10 or score == -10
      return score
    end
    row = -1
    col = -1
    if player == 1
      best = -999999
      moves.each do |move|
        row = move[0]
        col = move[1]
        @board.array2d[row][col] = player
        val = minimax(depth-1, 0)
        best = [best, val].max
        @board.array2d[row][col] = nil
      end
    else
      best = 999999
      moves.each do |move|
        row = move[0]
        col = move[1]
        @board.array2d[row][col] = player
        best = [best, minimax(depth-1, 1)].min
        @board.array2d[row][col] = nil
      end
    end

    return best
  end
  def eval_func(player, depth)
    mult = player == 1 ? 10 - depth : depth - 10
    return @board.someone_win? ? mult : 0
  end
  def next_ai_move
    best = -999999
    res = [-1, -1]
    @board.get_empty.each do |move|
      row = move[0]
      col = move[1]
      @board.array2d[row][col] = 1
      val = minimax(@maxdepth, 1)
      @board.array2d[row][col] = nil
      if val > best
        res = [row, col]
        best = val
      end
    end
    return res
  end
end

#brd = Board.new(4,4,3)
#brd.array2d = [ [0,1,0,0],
#                [1,1,0,1],
#                [0,0,1,1],
#                [1,2,2,0] ]
#puts brd.someone_win?.inspect
brd = Board.new(3,3,3)
gm = GameRunner.new(brd)
#gm.two_player
gm.one_player
