#!/usr/bin/env ruby
arr = File.readlines("data.txt")

def ranges_overlaps(range1, range2)
  range1.first <= range2.last && range2.first <= range1.last
end

def range_include?(range1, range2)
  range1.cover?(range2.min) && range1.cover?(range2.max)
end

def ranges_include?(range1, range2)
  range_include?(range1, range2) || range_include?(range2, range1)
end

def string_to_range(str)
  first, last = str.split("-").map(&:to_i)
  first..last
end

def string_pair_to_range(str)
  str.split(",").map { |str| string_to_range(str) }
end

def stars_1(arr)
  arr.count do |str|
    ranges = string_pair_to_range(str)
    ranges_include?(ranges.first, ranges.last)
  end
end

def stars_2(arr)
  arr.count do |str|
    ranges = string_pair_to_range(str)
    ranges_overlaps(ranges.first, ranges.last)
  end
end

puts stars_1(arr)
puts stars_2(arr)
