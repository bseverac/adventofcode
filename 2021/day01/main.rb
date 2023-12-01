#!/usr/bin/env ruby
arr = File.readlines('data.txt')
arr.map!(&:to_i)
compare = Proc.new { |arr| arr.first < arr.last }

puts arr.each_cons(2).select(&compare).count
puts arr.each_cons(4).select(&compare).count