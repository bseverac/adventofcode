#!/usr/bin/env ruby
arr = File.readlines('data.txt')
puts arr.map(&:to_i).combination(2).detect { |e| e.sum == 2020 }.inject(:*)
puts arr.map(&:to_i).combination(3).detect { |e| e.sum == 2020 }.inject(:*)
