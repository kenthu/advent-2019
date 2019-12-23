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

  def self.calculate_blocking_coordinates(target_coordinates)
    # puts "Finding coordinates blocking #{target_coordinates}" if DEBUG
    return Set.new if target_coordinates == [0, 0]
    greatest_common_divisor = target_coordinates[0].gcd(target_coordinates[1])
    atomic_step = [
      target_coordinates[0] / greatest_common_divisor,
      target_coordinates[1] / greatest_common_divisor
    ]
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
