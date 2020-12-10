#!/usr/bin/ruby
require 'test/unit'
require 'pry'

def resolve_1(arr)
  diff = arr.push(0).sort.each_cons(2).map { |e| e.inject(&:-) }
  diff.count { |v| v == -1 } * (diff.count { |v| v == -3 } + 1)
end

def resolve_2(arr)
  arr.push(0).sort.each_with_object([1]) do |e, lengthes|
    lengthes[e] = lengthes[([0, e-3].max)..([0, e-1].max)].compact.sum
  end.last
end


class Day10Test < Test::Unit::TestCase
  def data(name)
    File.read(name).split("\n").map(&:to_i)
  end

  def arr_test
    data('data_test.txt')
  end

  def arr
    data('data.txt')
  end

  def test_1
    assert_equal 220, resolve_1(arr_test)
  end

  def test_1_final
    assert_equal 2170, resolve_1(arr)
  end

  def test_2
    assert_equal 19208, resolve_2(arr_test)
  end

  def test_2_final
    assert_equal 24803586664192, resolve_2(arr)
  end
end
