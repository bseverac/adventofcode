#!/usr/bin/ruby
require 'test/unit'
require 'pry'

extend Test::Unit::Assertions

def id(str)
  row(str) * 8 + col(str)
end

def row(str)
  binary_split('F', str[/^.{7}/], 0..127).first
end

def col(str)
  binary_split('L', str[/.{3}$/], 0..7).first
end

def binary_split(left_split_chr, str, range)
  return range if str.length == 0
  middle = (range.max - range.first) / 2.0 + range.first
  binary_split(
    left_split_chr,
    str[1..-1],
    str[0] == left_split_chr ? range.first..middle.floor : middle.ceil..range.max
  )
end

puts '==================================='
puts '============SOLUTION1=============='
arr = File.readlines('data.txt')
arr = arr.map(&:strip)
ids = arr.map(&method(:id))
puts ids.max
puts '==================================='
puts '==================================='
puts '============SOLUTION2=============='
puts (
  (0..ids.max).to_a - ids).sort.last
## Tests

class Day5 < Test::Unit::TestCase
  def test_binary_split
    assert_equal(0..127, binary_split('F', '', 0..127))
    assert_equal(0..63, binary_split('F', 'F', 0..127))
    assert_equal(64..127, binary_split('F', 'B', 0..127))
    assert_equal(32..63, binary_split('F', 'FB', 0..127))
    assert_equal(32..47, binary_split('F', 'FBF', 0..127))
    assert_equal(40..47, binary_split('F', 'FBFB', 0..127))
    assert_equal(44..47, binary_split('F', 'FBFBB', 0..127))
    assert_equal(44..45, binary_split('F', 'FBFBBF', 0..127))
    assert_equal(44..44, binary_split('F', 'FBFBBFF', 0..127))
  end

  def test_row
    assert_equal(44, row('FBFBBFFRLR'))
  end

  def test_col
    assert_equal(5, col('FBFBBFFRLR'))
  end

  def test_id
    assert_equal(357, id('FBFBBFFRLR'))
  end
end
