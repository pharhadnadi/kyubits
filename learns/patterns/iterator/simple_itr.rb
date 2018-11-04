class Iterator
  attr_accessor :tree

  def initialize bintree, type = 'pre'
    @tree = bintree
    @itr = case type
             when /pre/
               PreorderIterator.new bintree
             when /in/
               InorderIterator.new bintree
             when /post/
               PostorderIterator.new bintree
             else
               raise "unknown itr type passed: #{type}"
           end
  end

  def has_next?
    @itr.has_next?
  end

  def next
    @itr.next
  end
end


class PreorderIterator
  attr_accessor :tree

  def initialize bintree
    @tree = bintree
    @stk = []
    @stk << bintree.root if bintree.root
  end

  def has_next?
    !@stk.empty?
  end

  def has_next_ino?
    !@stk.empty?
  end

  def next
    if has_next?
      node = @stk.pop
      @stk << node.right if node.right
      @stk << node.left if node.left
      node.data
    end
  end

end


class InorderIterator
  attr_accessor :tree

  def initialize bintree
    @tree = bintree
    @stk = []
    left_seek bintree.root if bintree.root
  end

  def has_next?
    !@stk.empty?
  end

  def next
    if has_next?
      node = @stk.pop
      left_seek node.right if node.right
      node.data
    end
  end

  private
  def left_seek node
    @stk << node if node
    while node.left do
      node = node.left
      @stk << node
    end
  end

end


class PostorderIterator
  attr_accessor :tree

  def initialize bintree
    @tree = bintree
    @stk = []
    fill_stk bintree.root if bintree.root
  end

  def has_next?
    !@stk.empty?
  end

  def next
    if has_next?
      node = @stk.pop
      node.data
    end
  end

  private
  def fill_stk node
    @stk << node if node
    fill_stk node.right if node.right
    fill_stk node.left if node.left
  end

end
