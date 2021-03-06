class Node
  attr_accessor :name, :links

  def initialize name
    @name = name
    @links = {}
    @weight = 0
  end

  def add_link node
    @links[node.name] = node
    weigh
  end

  def chop_link node
    @links.delete(node.name)
    weigh
  end

  def weigh
    @weight = @links.size
  end

  def all_links
    @links.keys
  end
end

class MyTree
  attr_accessor :name, :nodes

  def initialize name, first_node
    @name = name
    @nodes = {}
    make_node(first_node)
  end

  def make_node node
    @nodes[node] = @nodes[node] || Node.new(node)
  end

  def link_nodes node_1, node_2
    node_1, node_2 = make_node(node_1), make_node(node_2)
    node_1.add_link node_2
    node_2.add_link node_1
  end

  def chop_link node_1, node_2
    node_1.chop_link node_2
    node_2.chop_link node_1
    clean_up node_2
  end

  def clean_up node
    delete_q = node.name
    until delete_q.empty?
      delete_q.pop do |n|
        delete_q += node.all_links
        @nodes.delete(n)
      end
    end
  end

  def count
    @nodes.keys.length # returns count of all the nodes
  end

  def merge tree
    @nodes.merge! tree.nodes
  end

  def leaves limit = nil
    res = []
    @nodes.each do |n, val|
      res << n if val.branches == 1
      break if limit and res.size >= limit
    end
    res
  end

  def all_nodes
    @nodes.keys
  end
end


class Forest
  attr_accessor :name, :trees, :nodes

  def initialize name, node_count
    @name = name
    @nodes = {}
    @trees = {}
    @tree_count = 0
    @node_count = node_count
  end

  def sow node_1, node_2
    t_n1, t_n2 = @nodes[node_1], @nodes[node_2]
    if t_n1 and t_n2
      if t_n1 != t_n2 # don't count repeats
        big_tree, small_tree = t_n1.count > t_n2.count ? [t_n1, t_n2] : [t_n2, t_n1]
        transfer small_tree, big_tree
        big_tree.merge small_tree
        @trees.delete(small_tree.name)
      else
        t_n1.link_nodes node_1, node_2
      end
    elsif t_n1.nil? and t_n2.nil?
      add_tree node_1, node_2
    elsif t_n1.nil?
      tree = t_n2
      @nodes[node_1] = tree
      tree.link_nodes node_2, node_1
    else
      tree = t_n1
      @nodes[node_2] = tree
      tree.link_nodes node_1, node_2
    end
  end

  def transfer from_tree, to_tree
    from_tree.nodes.keys.each do |node|
      @nodes[node] = to_tree
    end
  end

  def add_tree node_1, node_2 = nil
    @trees[@tree_count] = MyTree.new(@tree_count, node_1)
    tree = @trees[@tree_count]
    @nodes[node_1] = tree
    if node_2
      @nodes[node_2] = tree
      tree.link_nodes node_1, node_2
    end
    @tree_count+=1
  end

  def count
    @trees.keys.length # returns count of all the trees
  end

  def make_remainders
    @node_count.times do |n|
      unless @nodes[n]
        add_tree n
      end
    end
  end

  def show_trees
    @trees.each do |t_name, t|
      puts "#{t_name} => #{t.nodes.keys} = #{t.count}"
    end
    @nodes.each do |n, t|
      puts "#{n} => #{t.name} => #{t.nodes[n].links.keys}"
    end
  end

  def fell
    remaining = t.all_nodes
    chain = 0
    until remaining.empty?
      leaf = t.leaves(1).first
      remaining -= leaf
      chain+=1
      while chain.odd?

      end
      chain = 0
    end
  end

  def ascend
    @trees.values.each do |t|
      nxts = t.leaves
      remaining = t.all_nodes
      visited = nxts
      cuts = 0 # increase as we get evens
      nxt_level = {}

      until remaining.empty?
        this_visit = []

        # step up once
        nxts.each do |en|
          ends = t.nodes[en].links.keys
          ends.each do |n|
            till_val = nxt_level[en] || 0
            unless visited.include? n
              this_visit << n
              nxt_level[n] ||= 0
              nxt_level[n] += till_val + 1
            end
          end
        end

        # count sums
        this_visit.uniq!
        visited += this_visit

        this_visit.each do |n|
          cut+=1 if nxt_level[n].odd?
        end

        remaining -= nxts
        nxts = nxt_level.keys
      end
      puts cuts
    end
  end

  def compute_pairs
    # make_remainders # takes too long!
    show_trees # for viz
    count_queue = []
    @trees.values.each do |t|
      count_queue << t.count
    end
    # lone = @node_count-@nodes.length
    lone = @node_count
    sum = (lone-1)*lone/2
    while count_queue.length > 0
      n = count_queue.pop
      # count_queue.each { |c| sum+=n*c }
      # sum+=lone*n
      sum-=(n-1)*n/2
    end
    sum
  end
end


N, i = gets.split.map { |x| x.to_i }

f = Forest.new 'gir', N
i.times do
  a, b = gets.split.map { |x| x.to_i }
  f.sow a, b
end

f.ascend
f.show_trees