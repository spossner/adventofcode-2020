# Definition for a binary tree node.
class TreeNode
  PREORDER = 1
  INORDER = 2
  POSTORDER = 3

  attr_accessor :val, :left, :right
  def initialize(val)
      @val = val
      @left, @right = nil, nil
  end

  def to_s
    "#{@val}: [ #{@left} | #{@right} ]"
  end

  def TreeNode.from_array(arr)
    return nil if arr.empty?
    tree = [[TreeNode.new(arr.shift)]]
    until arr.empty?
      new_level = []
      tree.last.each do |node|
        v = arr.shift
        if v
          node.left = TreeNode.new(v)
          new_level << node.left
        end
        v = arr.shift
        if v
          node.right = TreeNode.new(v)
          new_level << node.right
        end
      end
      tree << new_level
    end
    tree.first.first
  end

  def to_a(style = INORDER)
    result = []
    if style == PREORDER
      result << @val
    end
    if @left != nil
      result.concat @left.to_a(style)
    end
    if style == INORDER
      result << @val
    end
    if @right != nil
      result.concat @right.to_a(style)
    end
    if style == POSTORDER
      result << @val
    end
    return result
  end
end
