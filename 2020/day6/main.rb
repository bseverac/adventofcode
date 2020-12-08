#!/usr/bin/ruby
require 'test/unit'
require 'pry'

def count_1(arr)
  arr.join.split("\n\n").map do |group|
    group.gsub("\n", '').split(//).uniq.count
  end.sum
end

def count_2(arr)
  arr.join.split("\n\n").map do |group|
    group.split("\n").map{ |l| l.split(//)}.inject(&:&).count
  end.sum
end

puts '==================================='
puts '============SOLUTION1=============='
arr = File.readlines('data.txt')
puts count_1(arr)
puts '==================================='
puts '==================================='
puts '============SOLUTION2=============='
puts count_2(arr)


class Day6 < Test::Unit::TestCase
  def test_count_1
    assert_equal 2, count_1(["a\na\n\n",'b'])
  end
  def test_count_2
    assert_equal 2, count_2(["a\na\n\n","ab\na"])
  end
end
