class TrieNode
  attr_accessor :children, :val, :isLast
  def initialize(val=nil, isLast=false)
    @val = val
    @children = {}
    @isLast = isLast
  end
end

class PrefixTrie
  def initialize
    @root = TrieNode.new
  end
  def insert(word)
    curNode = @root
    size = word.length
    cnt = 0
    while cnt < size
      if curNode.children.include? word[cnt]
        curNode = curNode.children[word[cnt]]
        curNode.isLast = cnt == size -1? true: false
        puts "has cur #{curNode.val} #{curNode.isLast.inspect}"
        cnt += 1
      else
        break
      end
    end
    while cnt < size
      isLast = cnt == size -1? true: false
      curNode.children[word[cnt]] = TrieNode.new(word[cnt], isLast)
      curNode = curNode.children[word[cnt]]
      cnt += 1
    end
  end
  def startsWith(word)
    curNode = @root
    size = word.length
    cnt = 0
    while cnt < size
      if curNode.children.include? word[cnt]
        curNode = curNode.children[word[cnt]]
        cnt += 1
      else
        return false
      end
    end
    return true
  end
  def startsWithChildren(word)
    curNode = @root
    cnt = 0
    while cnt < word.length
      curNode = curNode.children[word[cnt]]
      if curNode == nil
        return []
      end
      cnt += 1
    end
    arry = getChildrenArray(curNode)
    arry.map{|sfx| word + sfx}
  end
  def getChildrenArray(node)
    res = []
    dfs(node, res, [])
    res
  end
  def dfs(node, res, cur)
    puts "cur #{node.val} #{node.isLast.inspect}"
    if node.children.empty? || node.isLast
      res.push(cur.join())
    end
    node.children.each do |key, childNode|
      cur.push(key)
      dfs(childNode, res, cur)
      cur.pop()
    end
  end
end

pt = PrefixTrie.new
pt.insert("homez")
pt.insert("home")
pt.insert("homer")
pt.insert("hole")

puts "\tDoes it include 'hom'? : #{pt.startsWith('hom')}\n
  \tDoes it include 'homs'? : #{pt.startsWith('homs')}"
puts "All children of 'hom': #{pt.startsWithChildren('hom')}"
