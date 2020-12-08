#!/usr/bin/ruby
require 'test/unit'
require 'pry'

class Day8
  attr_accessor :acc
  def initialize(inst)
    @crs = 0
    @acc = 0
    @inst = inst
    play
  end

  def next
    return false if @inst[@crs] == nil || self.finished?
    op, val = @inst[@crs].split(' ')
    @inst[@crs] = nil
    @crs += (op == 'jmp' ? val.to_i : 1)
    @acc += (op == 'acc' ? val.to_i : 0)
    true
  end

  def play
    true while self.next
  end

  def finished?
    @crs >= @inst.count
  end
end

class Day8Test < Test::Unit::TestCase
  def test_1
    arr = File.read('data_test.txt').split("\n")
    d = Day8.new(arr)
    assert_equal 5, d.acc
  end

  def test_2
    arr = File.read('data.txt').split("\n")
    d = Day8.new(arr)
    assert_equal 1949, d.acc
  end

  def test_3
    arr = File.read('data.txt').split("\n")
    arr.each_with_index do |v, i|
      dup_a = File.read('data.txt').split("\n")
      if dup_a[i].match?('jmp')
        dup_a[i] = dup_a[i].gsub('jmp', 'nop')
      else
        dup_a[i] = dup_a[i].gsub('nop', 'jmp')
      end
      d = Day8.new(dup_a)
      puts d.acc if d.finished?
    end
  end
end
