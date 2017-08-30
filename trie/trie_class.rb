class TrieNode
  attr_accessor :children
  def initialize
    @children = {}
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
        cnt += 1
      else
        break
      end
    end
    while cnt < size
      curNode.children[word[cnt]] = TrieNode.new
      curNode = curNode.children[word[cnt]]
      cnt += 1
    end
  end
end

pt = PrefixTrie.new
pt.insert("home")
pt.insert("hole")
pt.insert("homer")
