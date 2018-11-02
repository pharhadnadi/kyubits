# Path Sum
# Go to Discuss
# Given a binary tree and a sum, determine if the tree has a root-to-leaf path such that adding up all the values along the path equals the given sum.
#
#     Note: A leaf is a node with no children.
#
#     Example:
#
#     Given the below binary tree and sum = 22,
#
#       5
#      / \
#     4   8
#    /   / \
#   11  13  4
#  /  \      \
# 7    2      1
# return true, as there exist a root-to-leaf path 5->4->11->2 which sum is 22.

# Definition for a binary tree node.
# class TreeNode
#     attr_accessor :val, :left, :right
#     def initialize(val)
#         @val = val
#         @left, @right = nil, nil
#     end
# end

# @param {TreeNode} root
# @param {Integer} sum
# @return {Boolean}
def has_path_sum(root, sum)
  return false if root.nil?
  pre root,sum
end

def pre node,sum
  return false if node.nil?
  sum -= node.val
  return sum == 0 if is_leaf(node)
  return (pre(node.left,sum) or pre(node.right,sum))
end

def is_leaf node
  node.left.nil? and node.right.nil?
end
