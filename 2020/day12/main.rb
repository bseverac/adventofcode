#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'

DIRECTIONS = {
  N: Vector[0, -1],
  S: Vector[0, 1],
  E: Vector[1, 0],
  W: Vector[-1, 0]
}
TURNS = { L: -1, R: 1 }
class Ship
  attr_accessor :pos
  def initialize(vx, vy, insts = [], star1 = true)
    @pos = Vector[0, 0]
    @speed = Vector[vx, vy]
    insts.each { |inst| self.exec(inst, star1)}
  end

  def exec(inst, star1 = true)
    m = inst.match(/^(?<action>.)(?<val>\d+)$/)
    action = m[:action].to_sym
    val = m[:val].to_i
    if DIRECTIONS.keys.include? action
      eval("#{star1 ? :@pos : :@speed} += #{DIRECTIONS[action] * val}")
    elsif TURNS.keys.include? action
      (val / 90).times {|t| @speed = (@speed * TURNS[action]).cross_product }
    elsif action == :F
      @pos += @speed * val
    end
  end

  def manhattan
    @pos[0].abs + @pos[1].abs
  end
end


class Day12Test < Test::Unit::TestCase
  def data(name)
    File.read(name).split("\n")
  end

  def test_move_to
    s = Ship.new(1, 0)
    s.exec("N10")
    assert_equal Vector[0, -10], s.pos
    s.exec("S5")
    assert_equal Vector[0, -5], s.pos
    s.exec("F1")
    assert_equal Vector[1, -5], s.pos
    s.exec("L90")
    s.exec("F1")
    assert_equal Vector[1, -6], s.pos
  end

  def test_star_1
    tab = data('data_test.txt')
    s = Ship.new(1, 0, tab)
    assert_equal 25, s.manhattan
  end

  def test_star_1_final
    tab = data('data.txt')
    s = Ship.new(1, 0, tab)
    assert_equal 757, s.manhattan
  end

  def test_star_2
    tab = data('data_test.txt')
    s = Ship.new(10, -1, tab, false)
    assert_equal 286, s.manhattan
  end

  def test_star_2_final
    tab = data('data.txt')
    s = Ship.new(10, -1, tab, false)
    assert_equal 51249, s.manhattan
  end
end
