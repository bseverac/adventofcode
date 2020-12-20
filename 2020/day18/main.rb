#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'

PLUS       = /(\d+ \+ \d+)/
CROSS      = /(\d+ \* \d+)/
OP         = /^(\d+ [\+\*] \d+)/
SINGLE_OP  = /\(([\d +\*])*\)/ # extract single parenthesis expression ex: (2 + 3)
PARENTH    = /[\(\)]+/

def calc(str, prio)
  str.sub!(SINGLE_OP) { |a| calc(a.gsub(PARENTH, ''), prio) } while str.include?('(')
  prio.each { |r| str.sub!(r) { |a| eval(a) } while str.match(r) }
  str.to_i
end

#start     17:32
#end       19:18
#refactro  19:30
class Day18Test < Test::Unit::TestCase
  def test_star_1
    assert_equal 51, calc('1 + (2 * 3) + (4 * (5 + 6))', [OP])
    assert_equal 13632, calc('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2', [OP])
  end

  def test_star_1_final
    data = File.read('data.txt')
    assert_equal 3885386961962, data.split("\n").map { |str| calc(str, [OP]) }.sum
  end

  def test_star_2
    data = File.read('data.txt')
    assert_equal 51, calc('1 + (2 * 3) + (4 * (5 + 6))', [PLUS, CROSS])
    assert_equal 46, calc('2 * 3 + (4 * 5)', [PLUS, CROSS])
    assert_equal 23340, calc('((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2', [PLUS, CROSS])
  end

  def test_star_2_final
    data = File.read('data.txt')
    assert_equal 112899558798666, data.split("\n").map { |str| calc(str, [PLUS, CROSS]) }.sum
  end
end
