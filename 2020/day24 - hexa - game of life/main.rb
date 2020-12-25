#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'
require 'digest'

#axial coordinates
DIR = { w:  [-1,  0], nw: [ 0, -1], ne: [ 1, -1], e:  [ 1,  0], se: [ 0,  1], sw: [-1,  1] }

class Game
  attr_accessor :cells

  def initialize(blacks)
    @cells = {}
    blacks.each { |black|
      self.add_cell(black)
    }
  end

  def step
    @cells = cells_to_evaluate.each_with_object({}) do |c, cells|
      cells[c] = true if activated?(c)
    end
  end

  def activated?(c)
    (@cells[c] && (1..2).include?(closed_active(c))) ||
    (!@cells[c] && closed_active(c) == 2)
  end

  def cells_to_evaluate
    @cells.map { |c, _| closed_cells(c) + [c] }.flatten(1).uniq
  end

  def add_cell(c)
    @cells[c] = true
  end

  def closed_cells(c)
    DIR.values.map{ |ac|
      c.zip(ac).map(&:sum)
    }
  end

  def closed_active(c)
    closed_cells(c).count { |c| @cells[c] }
  end
end

class Tile
  attr_accessor :pos
  def initialize(name)
    tiles = File.read(name).split("\n").map{ |str| Tile.str_to_a(str) }
    @pos = tiles.map { |tile| Tile.pos(tile) }
  end

  def blacks
    @pos.group_by(&:to_a).map{|k,v| [k, v.count]}.to_h.select{|k,v| v%2 == 1}.keys
  end

  def resolve_1
    blacks.count
  end

  def self.pos(tile)
    pos = [0,0]
    tile.each do |dir|
      pos = pos.zip(DIR[dir.to_sym]).map(&:sum)
    end
    pos
  end

  def self.str_to_a(str)
    str.scan(/se|sw|nw|ne|e|w/)
  end
end

class Day24Test < Test::Unit::TestCase
  def test_star_1
    assert_equal [0,0], Tile.pos(Tile.str_to_a('nwwswee'))
    assert_equal [0,1], Tile.pos(Tile.str_to_a('esew'))
    tile = Tile.new('data_test.txt')
    assert_equal 10, tile.resolve_1
  end

  def test_star_1_final
    tile = Tile.new('data.txt')
    assert_equal 269, tile.resolve_1
  end

  def test_star_2
    tile = Tile.new('data_test.txt')
    g = Game.new(tile.blacks)
    100.times { |i| g.step }
    assert_equal 2208, g.cells.count
  end

  def test_star_2_final
    tile = Tile.new('data.txt')
    g = Game.new(tile.blacks)
    100.times { |i| g.step }
    assert_equal 2208, g.cells.count
  end
end
