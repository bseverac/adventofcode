#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'
class Day15
  def initialize(list)
    @previous = list
    @memory = {}
    list.each_with_index do |e, index|
      @memory[e] ||= []
      @memory[e] << index + 1
    end
  end

  def loop(times)
    (times - @previous.count).times { |_| self.step }
    self
  end

  def step
    previous = @previous[-1]
    if @memory[previous]
      @memory[previous] << @previous.length
      @previous << @memory[previous].last(2).inject(:-).abs
    else
      @memory[previous] = [@previous.length]
      @previous << 0
    end
  end

  def result
    @previous[-1]
  end
end

class Day12Test < Test::Unit::TestCase
  def test_star_1_test_2
    assert_equal 436,   Day15.new([0,3,6]).loop(2020).result
    assert_equal 1,     Day15.new([1,3,2]).loop(2020).result
    assert_equal 10,    Day15.new([2,1,3]).loop(2020).result
    assert_equal 27,    Day15.new([1,2,3]).loop(2020).result
    assert_equal 78,    Day15.new([2,3,1]).loop(2020).result
    assert_equal 438,   Day15.new([3,2,1]).loop(2020).result
    assert_equal 1836,  Day15.new([3,1,2]).loop(2020).result
  end

  def test_star_1_final
    assert_equal 289,     Day15.new([0,8,15,2,12,1,4]).loop(2020).result
  end

  def test_star_2_final
    assert_equal 1505722, Day15.new([0,8,15,2,12,1,4]).loop(30000000).result
  end
end
