#!/usr/bin/env ruby
# frozen_string_literal: true

arr = File.readlines('data.txt')
arr.map!(&:to_i)
compare = proc { |a| a.first < a.last }

puts arr.each_cons(2).select(&compare).count
puts arr.each_cons(4).select(&compare).count
