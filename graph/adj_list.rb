require 'set'
graph = [ [1, 6, 8],
  [0, 4, 6, 9],
  [4, 6],
  [4, 5, 8],
  [1, 2, 3, 5, 9],
  [3, 4],
  [0, 1, 2],
  [8, 9],
  [0, 3, 7],
  [1, 4, 7] ]

#cyclic_dir_g = [[0],[1]]
dir_g = [ [],
  [4,6] ,
  [7],
  [7,4],
  [5],
  [],
  [],
  [0]
]

class AdjListGraph
  attr_accessor :val
  def initialize(val)
    @val = val
    @visited = Set.new
    @half_visited = Set.new
  end
  def dfs
    @visited = Set.new
    puts "Depth first search:"
    dfs_vertex(0)
  end
  def dfs_vertex(vertex)
    @visited.add(vertex)
    puts "visited #{vertex}"
    @val[vertex].each do |adj|
      if !@visited.include? adj
        dfs_vertex(adj)
      end
    end
  end
  def iddfs
    @visited = Set.new
    max_depth = 10
    puts "Iterative deepening Depth first search (Max depth #{max_depth}):"
    (0..max_depth).to_a.each do |depth|
      dls(0, depth)
    end
  end
  def dls(vertex, depth)
    if depth == 0
      if !@visited.include? vertex
        @visited.add(vertex)
        puts "visited #{vertex}"
      end
      return
    end
    @val[vertex].each do |adj|
      dls(adj, depth-1)
    end
  end
  def bfs
    @visited = Set.new
    puts "Breadth first search:"
    queue = [0]
    @visited.add(queue[0])
    puts "visited #{queue[0]}"
    while queue.length > 0
      vtx = queue.shift
      @val[vtx].each do |adj|
        if !@visited.include? adj
          @visited.add(adj)
          puts "visited #{adj}"
          queue.push(adj)
        end
      end
    end

    queue.each do |adj_list|
    end
  end
  def show
    puts @val.map { |x| x.join(' ') }
  end
  def topo_sort
    puts "Topological sort"
    @visited = Set.new
    @half_visited = Set.new
    res = []
    (0..@val.length-1).to_a.each do |vtx|
      topo_helper(vtx, res)
    end
    res
  end
  def topo_helper(vtx, res)
    if @visited.include? vtx
      return
    end
    if @half_visited.include? vtx
      raise Exception, "Not a DAG, #{vtx} part of a cycle"
      return
    end
    @half_visited.add(vtx)
    @val[vtx].each do |adj|
      topo_helper(adj, res)
    end
    @visited.add(vtx)
    @half_visited.delete(vtx)
    res.unshift(vtx)
  end
end

adjGraph = AdjListGraph.new(graph)
puts "#{adjGraph.val.length} vertices"
adjGraph.dfs
adjGraph.bfs
adjGraph.iddfs

directedGraph = AdjListGraph.new(dir_g)
puts directedGraph.topo_sort.inspect
