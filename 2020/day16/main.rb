#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'

class Day16
  def initialize(name)
    data = File.read(name)
    m = data.match(/(?<r>[\W\w]*)your ticket:\n(?<my>[\W\w]*)nearby tickets:\n(?<t>[\W\w]*)/)
    @fields = m[:r].split("\n").map do |rules_str|
      name, rules = rules_str.split(':')
      {
        name: name,
        ranges: rules.split('or').map {|str| Range.new(*(str.split('-').map(&:to_i)))},
        is_not_index: [], is_index: nil
      }
    end
    @my = m[:my].split(',').map(&:to_i)
    @tickets = m[:t].split("\n").map{ |e| e.split(',').map(&:to_i) }
    self
  end

  def resolve_1
    @tickets.flatten.select { |value| self.is_value_valid?(value) }.sum
  end

  def is_value_valid?(value)
    @fields.map {|r| r[:ranges] }.flatten.all? { |range| !range.include? value }
  end

  def resolve_2
    @tickets.select{ |ticket| is_valid?(ticket) }.each do |ticket|
      ticket.each_with_index { |value, i|
        @fields.each do |field|
          (field[:is_not_index] << i).uniq! if field[:ranges].all?{ |range| !range.include? value }
        end
      }
    end
    @fields.sort_by {|f| f[:is_not_index].count }.reverse.each do |field|
      field[:is_index] = ((0...@fields.count).to_a - field[:is_not_index] - @fields.map {|f| f[:is_index]}.compact).first
    end
    @fields.select{ |f| f[:name].match?(/^departure/) }.map {|f| @my[f[:is_index]]}.inject(&:*)
  end

  def is_valid?(ticket)
    ticket.select { |value| self.is_value_valid?(value) }.empty?
  end
end

class Day16Test < Test::Unit::TestCase
  def test_star_1
    assert_equal 71, Day16.new('data_test.txt').resolve_1
  end

  def test_star_1_final
    assert_equal 23054, Day16.new('data.txt').resolve_1
  end

  def test_star_2
    assert_equal 51240700105297, Day16.new('data.txt').resolve_2
  end
end
