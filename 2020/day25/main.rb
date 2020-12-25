#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'
require 'digest'

def find_transform(subject, target)
  current = 1
  size = 0
  while current != target
    size += 1
    current = (current * subject) % 20201227
  end
  size
end

def transform(size, subject)
  current = 1
  size.times do |i|
    current = (current * subject) % 20201227
  end
  current
end

class Day22Test < Test::Unit::TestCase
  def test_star_1
    assert_equal 5764801, transform(8, 7)
    assert_equal 17807724, transform(11, 7)

    assert_equal 8, find_transform(7, 5764801)
    assert_equal 11, find_transform(7, 17807724)

    assert_equal 14897079, transform(11, 5764801)
    assert_equal 14897079, transform(8, 17807724)
  end

  def test_star_1_final
    size_a = find_transform(7, 15733400)
    size_b = find_transform(7, 6408062)

    assert_equal 16457981, transform(size_b, 15733400)
    assert_equal 16457981, transform(size_a, 6408062)
  end
end
