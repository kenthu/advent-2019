#!/usr/bin/env ruby

WIDTH = 25
HEIGHT = 6
FILENAME = 'day8_image.txt'.freeze

def read_layer(file)
  file.read(WIDTH * HEIGHT)
end

layers = []

open(FILENAME) do |file|
  loop do
    layer = read_layer(file)
    break unless layer
    layers << layer if layer.strip.length > 0
  end
end

def color(pixels)
  pixels.each do |pixel|
    return :black if pixel == '0'
    return :white if pixel == '1'
  end
  :transparent
end

# Part 1
layer_with_least_zeroes = layers.min_by { |layer| layer.split('').select { |pixel| pixel == '0' }.length }
one_digits = layer_with_least_zeroes.split('').select { |pixel| pixel == '1' }.length
two_digits = layer_with_least_zeroes.split('').select { |pixel| pixel == '2' }.length
puts one_digits * two_digits
# 2250

# Part 2
(0..HEIGHT-1).each do |row|
  (0..WIDTH-1).each do |column|
    index = row * WIDTH + column
    #print "#{index},"
    pixels = layers.map { |layer| layer[index] }
    pixel_color = color(pixels)
    case pixel_color
    when :black
      print ' '
    when :white
      print '█'
    end
  end
  puts ''
end
