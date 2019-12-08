#!/usr/bin/env ruby

def valid_password?(password)
  return false unless password =~ /\d{6}/
  last_digit = nil
  found_same_adjacent = false
  password.split('').each do |digit|
    found_same_adjacent = true if digit == last_digit
    return false if last_digit && digit < last_digit
    last_digit = digit
  end
  found_same_adjacent
end

def strictly_valid_password?(password)
  return false unless password =~ /\d{6}/
  has_adjacent?(password) && monotonically_increasing?(password)
end

def has_adjacent?(password)
  matches = password.scan(/(\d)(\1+)/)
  matches.any? { |match| match[1].length == 1 }
end

def monotonically_increasing?(password)
  last_digit = nil
  password.split('').each do |digit|
    return false if last_digit && digit < last_digit
    last_digit = digit
  end
  true
end

# Part 1
puts (240920..789857).select { |password_num| valid_password?(password_num.to_s) }.count
# 1154

# Part 2
puts (240920..789857).select { |password_num| strictly_valid_password?(password_num.to_s) }.count
# 750