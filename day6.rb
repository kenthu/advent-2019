#!/usr/bin/env ruby

CENTER_OF_MASS_VALUE = 'COM'.freeze
TEST_MAP = %w[COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L].freeze

class TreeNode
  attr_reader :value, :children

  def initialize(value)
    @value = value
    @children = []
  end

  def add_child(child_node)
    @children << child_node
  end

  def print
    puts "Printing node: #{@value}"
    puts "  Children: #{@children.map(&:value).map(&:to_s).join(', ')}"
    puts
    @children.each(&:print)
  end
end

class Tree
  def initialize(map)
    @node_hash = Hash.new { |hash, node_value| hash[node_value] = TreeNode.new(node_value) }
    @root = nil
    map.each { |map_entry| parse_map_entry(map_entry) }
  end

  def parse_map_entry(map_entry)
    parent_value, child_value = map_entry.split(')')
    parent_node = @node_hash[parent_value]
    child_node = @node_hash[child_value]
    parent_node.add_child(child_node)
    @root = parent_node if !@root && parent_value == CENTER_OF_MASS_VALUE
  end

  # Return sum of depths. Execute breadth-first tree traversal
  def orbit_count
    return 0 unless @root
    sum_of_depths = 0
    nodes_to_traverse = [{ node: @root, depth: 0 }]
    until nodes_to_traverse.empty?
      node_pair = nodes_to_traverse.shift
      node = node_pair[:node]
      depth = node_pair[:depth]
      sum_of_depths += depth
      node.children.each { |child| nodes_to_traverse << { node: child, depth: depth + 1 } }
    end
    sum_of_depths
  end

  def print
    @root.print if @root
  end
end

# Part 1 - Test
test_tree = Tree.new(TEST_MAP)
puts test_tree.orbit_count
# 42

# Part 1 - Execute
map = File.readlines('day6_map.txt').map(&:strip)
tree = Tree.new(map)
puts tree.orbit_count
# 204521