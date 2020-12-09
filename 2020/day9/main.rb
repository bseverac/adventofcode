#!/usr/bin/ruby
require 'test/unit'
require 'pry'

def is_sum(arr, target, pre_length)
  arr.combination(2).detect { |e| e.sum == target }
end

class Finder
  attr_accessor :arr, :target
  def initialize(arr, target)
    @arr, @target = arr, target
    @min, @max = 0, 1
  end

  def find_range
    while @max < arr.length
      return arr[@min..@max] if (curr_sum = arr[@min..@max].sum) == target
      curr_sum < target ? @max += 1 : @min += 1
    end
  end
end

def resolve_1(arr, pre_length)
  arr.each_cons(pre_length + 1).select { |list|
    !is_sum(list[0..-2], list[-1], pre_length)
  }.first.last
end

def resolve_2(arr, target)
  r = Finder.new(arr, target).find_range
  r.min + r.max
end


class Day8Test < Test::Unit::TestCase
  def data(name)
    File.read(name).split("\n").map(&:to_i)
  end

  def arr_test
    data('data_test.txt')
  end

  def arr
    data('data.txt')
  end

  def test_1_1_bis
    assert_equal 127, resolve_1(arr_test, 5)
  end

  def test_1_final
    assert_equal 542529149, resolve_1(arr, 25)
  end

  def test_2
    assert_equal 62, resolve_2(arr_test, 127)
  end

  def test_2_final
    assert_equal 75678618, resolve_2(arr, 542529149)
  end
end
