#!/usr/bin/env ruby

require 'pry'
require 'set'

DEBUG = false

TEST_1_EXPECTED_VALUE = { best_location: [3, 4], max_visible_asteroids: 8 }.freeze
TEST_2_EXPECTED_VALUE = { best_location: [5, 8], max_visible_asteroids: 33 }.freeze
TEST_3_EXPECTED_VALUE = { best_location: [1, 2], max_visible_asteroids: 35 }.freeze
TEST_4_EXPECTED_VALUE = { best_location: [6, 3], max_visible_asteroids: 41 }.freeze
TEST_5_EXPECTED_VALUE = { best_location: [11, 13], max_visible_asteroids: 210 }.freeze

class LineOfSightChecker
  @offset_map_cache = {}

  # Find all coordinates blocking this coordinate
  def self.blocking_coordinates(target_coordinates)
    unless @offset_map_cache.key?(target_coordinates)
      @offset_map_cache[target_coordinates] = calculate_blocking_coordinates(target_coordinates)
    end
    @offset_map_cache[target_coordinates]
  end

  def self.find_atomic_step(offset_coordinates)
    greatest_common_divisor = offset_coordinates[0].gcd(offset_coordinates[1])
    [
      offset_coordinates[0] / greatest_common_divisor,
      offset_coordinates[1] / greatest_common_divisor
    ]
  end

  def self.calculate_blocking_coordinates(target_coordinates)
    # puts "Finding coordinates blocking #{target_coordinates}" if DEBUG
    return Set.new if target_coordinates == [0, 0]
    atomic_step = find_atomic_step(target_coordinates)
    blocking_coordinates = Set.new
    coordinates_to_check = [0, 0]
    loop do
      coordinates_to_check = [
        coordinates_to_check[0] + atomic_step[0],
        coordinates_to_check[1] + atomic_step[1]
      ]
      break if coordinates_to_check[0].abs >= target_coordinates[0].abs && coordinates_to_check[1].abs >= target_coordinates[1].abs
      # puts "\tblocked by: #{coordinates_to_check}" if DEBUG
      blocking_coordinates << coordinates_to_check
    end
    blocking_coordinates
  end
end

class MonitoringStationOptimizer
  def initialize(map_filename)
    load_map(map_filename)
  end

  def load_map(map_filename)
    @asteroid_map = File.readlines(map_filename).map { |line| line.strip.split('') }.transpose
    @asteroids = Set.new
    @asteroid_map.each_with_index do |column, x|
      column.each_with_index do |cell, y|
        @asteroids << [x, y] if cell == '#'
      end
    end
    @map_width = @asteroid_map.length
  end

  def find_best_location
    max_visible_asteroids = 0
    best_location = nil
    @asteroids.each do |x, y|
      visible_asteroids = find_visible_asteroids(x, y)
      puts "A station at #{[x, y]} can see #{visible_asteroids} asteroids" if DEBUG
      if best_location.nil? || visible_asteroids > max_visible_asteroids
        best_location = [x, y]
        max_visible_asteroids = visible_asteroids
      end
    end
    { best_location: best_location, max_visible_asteroids: max_visible_asteroids }
  end

  def find_visible_asteroids(station_location_x, station_location_y)
    @asteroids.count do |asteroid_location_x, asteroid_location_y|
      offset = [
        asteroid_location_x - station_location_x,
        asteroid_location_y - station_location_y
      ]
      # Station cannot see the asteroid it's already on
      next false if offset == [0, 0]
      relative_blocking_coordinates = LineOfSightChecker.blocking_coordinates(offset)
      relative_blocking_coordinates.none? do |blocker_offset_x, blocker_offset_y|
        @asteroids.include? [
          station_location_x + blocker_offset_x,
          station_location_y + blocker_offset_y
        ]
      end
    end
  end

  # Going clockwise
  def self.radians_from_top(offset_coordinates)
    # Reverse the Y offset, since mathematical Y-axis is reverse of our Y-axis
    # Use the atan2 method to get the radians
    # Multiply result by -1 because we're going clockwise
    # Shift result by 0.5 * pi, because we start at 12 o'clock instead of 3 o'clock
    # Modulo with 2 * pi (full circle), to convert negatives
    offset_x, offset_y = offset_coordinates
    (-Math.atan2(-offset_y, offset_x) + 0.5 * Math::PI) % (2 * Math::PI)
  end

  def list_asteroids_by_zap_order(station_location)
    station_location_x, station_location_y = station_location
    asteroids_with_metadata = @asteroids.map do |asteroid_location_x, asteroid_location_y|
      offset = [
        asteroid_location_x - station_location_x,
        asteroid_location_y - station_location_y
      ]
      next if offset == [0, 0]
      atomic_step = LineOfSightChecker.find_atomic_step(offset)
      radians = self.class.radians_from_top(atomic_step)
      distance = Math.sqrt(offset[0]**2 + offset[1]**2)
      { radians: radians, distance: distance, coordinates: [asteroid_location_x, asteroid_location_y] }
    end.compact
    all_asteroids = []
    grouped_asteroids = asteroids_with_metadata.group_by { |asteroid| asteroid[:radians] }
    grouped_asteroids.each_value do |asteroids_for_angle|
      asteroids_for_angle.sort_by! { |asteroid| asteroid[:distance] }
      asteroids_for_angle.each_with_index { |asteroid, i| asteroid[:order] = i }
      all_asteroids += asteroids_for_angle
    end
    sorted_asteroids = all_asteroids.sort_by { |asteroid| [asteroid[:order], asteroid[:radians]] }
    sorted_asteroids.each_with_index do |asteroid, i|
      puts "#{i+1}\t#{asteroid[:coordinates]}"
    end
  end
end

# Part 1 - Test
raise 'Test 1 failed' unless MonitoringStationOptimizer.new('day10_test_1.txt').find_best_location == TEST_1_EXPECTED_VALUE
raise 'Test 2 failed' unless MonitoringStationOptimizer.new('day10_test_2.txt').find_best_location == TEST_2_EXPECTED_VALUE
raise 'Test 3 failed' unless MonitoringStationOptimizer.new('day10_test_3.txt').find_best_location == TEST_3_EXPECTED_VALUE
raise 'Test 4 failed' unless MonitoringStationOptimizer.new('day10_test_4.txt').find_best_location == TEST_4_EXPECTED_VALUE
raise 'Test 5 failed' unless MonitoringStationOptimizer.new('day10_test_5.txt').find_best_location == TEST_5_EXPECTED_VALUE

# Part 1 - Execute
puts MonitoringStationOptimizer.new('day10_map.txt').find_best_location
# {:best_location=>[37, 25], :max_visible_asteroids=>309}

# Part 2 - Test
# MonitoringStationOptimizer.new('day10_test_6.txt').list_asteroids_by_zap_order([8, 3])
# MonitoringStationOptimizer.new('day10_test_5.txt').list_asteroids_by_zap_order([11, 13])
MonitoringStationOptimizer.new('day10_map.txt').list_asteroids_by_zap_order([37, 25])
# 200	[4, 16] => 416