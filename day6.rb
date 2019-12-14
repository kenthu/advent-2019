#!/usr/bin/env ruby

ROOT_VALUE = 'COM'.freeze  # COM == Center Of Mass
TEST_MAP_PART_1 = %w[COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L].freeze
TEST_MAP_PART_2 = %w[COM)B B)C C)D D)E E)F B)G G)H D)I E)J J)K K)L K)YOU I)SAN].freeze

class TreeNode
  attr_reader :value, :children, :parent

  class ParentAlreadySetError < StandardError; end

  def initialize(value)
    @value = value
    @children = []
  end

  def add_child(child_node)
    @children << child_node
  end

  def set_parent(parent_node)
    raise ParentAlreadySetError if @parent
    @parent = parent_node
  end

  def ancestors
    my_ancestors = []
    current_node = self
    while (parent = current_node.parent)
      my_ancestors.unshift(parent)
      current_node = parent
    end
    my_ancestors
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
    child_node.set_parent(parent_node)
    @root = parent_node if !@root && parent_value == ROOT_VALUE
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

  def self.closest_common_ancestor(ancestors1, ancestors2)
    ancestors1.reverse_each do |ancestor|
      return ancestor if ancestors2.include?(ancestor)
    end
  end

  # Find minimum number of orbital transfers required to move from the object
  # YOU are orbiting to the object SAN is orbiting
  def transfers_to_reach_santa
    santa_ancestors = @node_hash['SAN'].ancestors
    you_ancestors = @node_hash['YOU'].ancestors
    closest_common_ancestor = self.class.closest_common_ancestor(santa_ancestors, you_ancestors)
    distance_from_common_to_santa = santa_ancestors.length - santa_ancestors.index(closest_common_ancestor) - 1
    distance_from_common_to_you = you_ancestors.length - you_ancestors.index(closest_common_ancestor) - 1
    distance_from_common_to_santa + distance_from_common_to_you
  end

  def print
    @root.print if @root
  end
end

# Part 1 - Test
test_tree = Tree.new(TEST_MAP_PART_1)
puts test_tree.orbit_count
# 42

# Part 1 - Execute
map = File.readlines('day6_map.txt').map(&:strip)
tree = Tree.new(map)
puts tree.orbit_count
# 204521

# Part 2 - Test
test_tree_2 = Tree.new(TEST_MAP_PART_2)
puts test_tree_2.transfers_to_reach_santa
# 4

# Part 2 - Execute
puts tree.transfers_to_reach_santa
# 307
