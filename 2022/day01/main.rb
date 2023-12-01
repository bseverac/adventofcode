#!/usr/bin/env ruby
arr = File.read("data.txt").split("\n\n")
puts arr.map { |e| e.split("\n").map(&:to_i).sum }.max
puts arr.map { |e| e.split("\n").map(&:to_i).sum }.max(3).sum
