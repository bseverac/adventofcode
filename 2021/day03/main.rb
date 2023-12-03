#!/usr/bin/env ruby
arr = File.readlines('data.txt')

row = Array.new((arr.first.length - 1), 0)

arr.each do |line|
  puts [row, line.strip.each_char.map(&:to_i)].inspect
  row = [row, line.strip.each_char.map(&:to_i)].transpose.map(&:sum)
end
puts row.map { |v| v > arr.count / 2.0 ? 1 : 0 }.join.to_i(2) * row.map { |v| v > arr.count / 2.0 ? 0 : 1 }.join.to_i(2)
