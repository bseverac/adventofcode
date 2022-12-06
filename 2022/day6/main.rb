#!/usr/bin/env ruby
str = File.read("data.txt")

# find index of x consecutive different letters 

def find_index(str, x)
  str.chars.each_cons(x).with_index do |arr, i|
    return i + x if arr.uniq.size == x
  end
end

puts find_index(str, 4)
puts find_index(str, 14)