#!/usr/bin/env ruby
require 'test/unit'
extend Test::Unit::Assertions

def fuel(value)
  (value / 3).round - 2
end

def recurcive_fuel(value)
  fuel = fuel(value)
  return 0 if fuel <= 0
  fuel + recurcive_fuel(fuel)
end

def module_fuel(arr, method = :fuel)
  arr.map(&method(method)).sum
end

arr = File.readlines('data.txt')
arr = arr.map(&:strip)

puts '==================================='
puts '============SOLUTION1=============='
puts module_fuel(arr.map(&:to_i))
puts '==================================='

puts '==================================='
puts '============SOLUTION2=============='
puts module_fuel(arr.map(&:to_i), :recurcive_fuel)
puts '==================================='

## Tests

class Day1 < Test::Unit::TestCase
  def test_fuel
    assert_equal fuel(12), 2
    assert_equal fuel(14), 2
    assert_equal fuel(1969), 654
    assert_equal fuel(100756), 33583
  end

  def test_module_fuel
    assert_equal module_fuel([12, 14]), 4
  end

  def test_recurcive_fuel
    assert_equal recurcive_fuel(14), 2
    assert_equal recurcive_fuel(14), 2
    assert_equal recurcive_fuel(1969), 966
    assert_equal recurcive_fuel(100756), 50346
  end
end
