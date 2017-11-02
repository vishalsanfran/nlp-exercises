class Maze
  def initialize(rows, cols, wall="|", path="-")
    @brd = Array.new(rows){Array.new(cols){wall}}
    @path = path
  end

  def get_moves(row, col)
    r_offs = [-1, 1, 0, 0]
    c_offs = [0, 0, 1, -1]
    moves = r_offs.each_with_index.map{|off, idx| [off + row, c_offs[idx] + col]}
    moves.select{|move| is_valid(move[0], move[1])}
  end

  def get_valid_moves(row, col)
    moves = get_moves(row, col)
    moves.select{|move| @brd[move[0]][move[1]] != @path}
  end

  def is_valid(row, col)
    row >= 0 && row < @brd.length && col >= 0 && col < @brd[0].length
  end

  def get_starting_pos
    prng = Random.new
    is_row = prng.rand(2) == 1? true : false
    st_row = is_row ? prng.rand(@brd.length) : 0
    st_col = is_row ? 0: prng.rand(@brd[0].length)
    [st_row, st_col]
  end

  def no_self_loop(row, col)
    all_moves = get_moves(row, col)
    tmp = all_moves.select{|move| @brd[move[0]][move[1]] == @path}
    all_moves.select{|move| @brd[move[0]][move[1]] == @path}.length <= 1
  end

  def set_prim_maze(rand_start=false)
    move = rand_start ? get_starting_pos() : [0, 0]
    @brd[move[0]][move[1]] = @path
    #puts "pos #{move}"
    moves = get_valid_moves(move[0], move[1])
    while moves.length > 0
      move = pop_random(moves)
      if no_self_loop(move[0], move[1])
        @brd[move[0]][move[1]] = @path
        moves += get_valid_moves(move[0], move[1])
      end
    end
    show
  end

  def show
    @brd.each do |row|
      puts row.join
    end
    print "\n"
  end

  def pop_random(list)
    prng = Random.new
    list.delete_at(prng.rand(list.length))
  end
end
def get_maze_rows_cols(deflt_rows=15, deflt_cols=20)
  begin
    rows = ARGV.length >= 1 ? ARGV[0].to_i : deflt_rows
    cols = ARGV.length >= 2 ? ARGV[1].to_i : deflt_cols
  rescue
    rows = deflt_rows
    cols = deflt_cols
  end
  puts "Presenting a #{rows} x #{cols} maze:"
  [rows, cols]
end

row_col = get_maze_rows_cols

maze = Maze.new(row_col[0], row_col[1])
maze.set_prim_maze
