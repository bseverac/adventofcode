#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'

DIRECTIONS = { R: [1, 0], L: [-1, 0], D: [0, 1], U: [0, -1] }

def cells(str)
  cells = [{ pos: [0,0], step: 0 }]
  str.split(',').map { |action|
    direction = DIRECTIONS[action[0].to_sym]
    action[1..-1].to_i.times { |i| 
      pos = cells[-1][:pos].zip(direction).map{ |e| e.sum }
      cells << { pos: pos, step: cells[-1][:step] + 1 }
    }
  }
  cells
end

def file_cells(name)
  File.read(name).split("\n").map {|c| cells(c)}
end

def resolve_1(name)
  cells = file_cells(name).map{ |c| c.map {|l| l[:pos] }}
  interset = (cells[1] & cells[0]) - [[0,0]]
  interset.map{|pos| pos.map(&:abs).sum }.min
end

def resolve_2(name)
  obj = file_cells(name)
  cells = obj.map{ |c| c.map {|l| l[:pos] }}
  interset = (cells[1] & cells[0]) - [[0,0]]
  interset.map do |interset|
    obj[0].find {|o| o[:pos] == interset }[:step] + obj[1].find {|o| o[:pos] == interset }[:step]
  end.min
end

class Day3Test < Test::Unit::TestCase
  def test_cells
    assert_equal [[0, 0], [1, 0], [2, 0], [2, 1], [2, 2]], cells('R2,D2').map{ |cell| cell[:pos] }
  end

  def test_1
    assert_equal 159, resolve_1('data_test.txt')
  end

  def test_1_final
    assert_equal 860, resolve_1('data.txt')
  end

  def test_2
    assert_equal 610, resolve_2('data_test.txt')
  end

  def test_2_final
    assert_equal 9238, resolve_2('data.txt')
  end
end
