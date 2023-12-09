#!/usr/bin/env ruby
# frozen_string_literal: true

arr1 = File.readlines('data_1.txt')
arr1 = arr1.map { _1.split.map(&:to_i) }

def next_step(arr)
  arr.each_cons(2).map { _1.reverse.inject(:-) }
end

def all_steps(arr)
  steps = [arr]
  steps << steps.last.each_cons(2).map { _1.reverse.inject(:-) } while steps.last.any? { _1 != 0 }
  steps
end

puts arr1.map { all_steps(_1).map(&:last).sum }.sum
puts arr1.map { all_steps(_1).map(&:first).reverse.reduce(0) { |acc, v| v - acc } }.sum
