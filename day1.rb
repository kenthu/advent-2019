#!/usr/bin/env ruby

TEST_MASSES = { 12 => 2, 14 => 2, 1969 => 654, 100_756 => 33_583 }.freeze
TEST_MASSES_COMPLEX = { 14 => 2, 1969 => 966, 100_756 => 50_346}.freeze

MASSES = [97587, 100963, 85693, 127587, 147839, 134075, 128598, 91290, 119100, 138824, 56295, 132118, 105018, 143092, 89032, 104836, 138278, 60416, 62570, 142110, 55179, 80891, 99106, 122863, 108894, 112654, 117175, 96093, 76214, 65412, 124388, 66465, 115850, 147531, 87643, 75882, 62912, 76100, 102120, 83803, 139304, 139325, 126412, 145152, 136247, 68246, 130156, 59097, 79024, 62480, 121847, 54739, 118690, 116247, 117283, 144827, 147562, 126796, 148210, 109099, 98831, 59412, 141077, 121786, 142878, 140144, 57855, 59571, 118451, 149097, 145088, 76882, 53732, 70543, 89874, 114366, 115683, 99139, 108440, 76964, 134451, 109250, 66021, 132683, 149013, 122917, 137810, 108451, 109606, 94396, 106926, 100901, 108587, 99847, 64257, 147162, 133698, 140775, 129466, 72487].freeze

# Specifically, to find the fuel required for a module, take its mass,
# divide by three, round down, and subtract 2.
def fuel(mass)
  mass / 3 - 2
end

def fuel_complex(mass)
  fuel_for_mass = fuel(mass)
  return 0 if fuel_for_mass <= 0
  fuel_for_mass + fuel_complex(fuel_for_mass)
end

TEST_MASSES.each do |input, expected_output|
  output = fuel(input)
  puts "Invalid output #{output} for input #{input}. Expected #{expected_output}" if output != expected_output
end

TEST_MASSES_COMPLEX.each do |input, expected_output|
  output = fuel_complex(input)
  puts "Invalid output #{output} for input #{input}. Expected #{expected_output}" if output != expected_output
end

puts "Part 1: #{MASSES.reduce(0) { |sum, mass| sum + fuel(mass) }}"
puts "Part 2: #{MASSES.reduce(0) { |sum, mass| sum + fuel_complex(mass) }}"
