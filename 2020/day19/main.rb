#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'

 class Day19
  def initialize(name)
    rules, @data = File.read(name).split("\n\n")
    parse_rules(rules)
  end

  def parse_rules(rules)
    @rules = {}
    rules.split("\n").each do |line|
      key, value = line.split(':')
      @rules[key] = value
    end
  end

  def reduce_rules(index)
    c = @rules[index.to_s][/\"(.+)\"/]
    return c[1] if c
    r = @rules[index].split('|').map do |rule|
      rule.scan(/(\d+)/).map { |m| reduce_rules(m.first) }.join
    end.join('|')
    "(#{r})"
  end

  def matches(index)
    regexp = reduce_rules(index)
    @data.split("\n").count { |str| str.match?(Regexp.new("^#{regexp}$")) }
  end
 end

class Day19Test < Test::Unit::TestCase
  def test_star_1
    assert_equal 2, Day19.new('data_test.txt').matches('0')
  end

  def test_star_1_final
    assert_equal 216, Day19.new('data.txt').matches('0')
    assert_equal 400, Day19.new('data2.txt').matches('0')
  end
end
