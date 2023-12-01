#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'

def match?(num)
  num.to_s.split(//).each_cons(2).all? {|a,b| a.to_i <= b.to_i } &&
  num.to_s.split(//).uniq.count != num.to_s.length
end

def match2?(num)
  num.to_s.split(//).each_cons(2).all? {|a,b| a.to_i <= b.to_i } &&
  num.to_s.split(//).group_by(&:to_i).values.map(&:count).find {|v| v == 2}
end

class Day4Test < Test::Unit::TestCase
  def test_1
    refute match?('123789')
    refute match?('132789')
    assert match?('113789')
    assert_equal 1686, (168630..718098).select { |num| match?(num) }.count
  end

  def test_2
    assert match2?('112233')
    refute match2?('123444')
    assert match2?('111122')
    assert_equal 1145, (168630..718098).select { |num| match2?(num) }.count
  end
end
