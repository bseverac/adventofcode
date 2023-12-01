#!/usr/bin/ruby
require 'test/unit'
require 'pry'

class Day7
  def initialize
    @data ||= { children: {}, parents: {}, links: {} }
  end

  def for_arr(arr)
    arr.each { |str| self.tree(str) }
    self
  end

  def tree(str)
    parent, children = children(str)
    self.add_parents(parent, children)
    self.add_childs(parent, children)
    self.add_links(parent, children)
  end

  def add_links(parent, children)
    children.each { |c|
      @data[:links][link_key(parent, c[:name])] = c[:num]
    }
  end

  def add_childs(parent, children)
    add(@data[:children], parent, children.map { |c| c[:name] })
  end

  def add_parents(parent, children)
    add(@data[:parents], parent, [])
    children.each { |c|
      add(@data[:parents], c[:name], parent)
    }
  end

  def add(hash, key, values)
    hash[key] ||= []
    hash[key].concat(Array(values)).uniq!
  end

  def flatten_parents(str)
    all_parents(str).flatten.uniq
  end

  def all_parents(str)
    @data[:parents][str] +
    @data[:parents][str].map { |parent| all_parents(parent) }
  end

  def count_strict_child(parent)
    count_child(parent) - 1
  end

  def count_child(parent)
    1 + @data[:children][parent].map do |c|
      count_child(c) * @data[:links][link_key(parent, c)]
    end.sum
  end

  def link_key(parent, child)
    "#{parent} -> #{child}"
  end
end

def children(str)
  parent, children = str.gsub(/\ bags?|\./, '').split(' contain ')
  [parent, split_children(children)]
end

def split_children(str)
  str.split(', ').map do |e|
     m = e.match(/(\d)\ (.*)/)
     { num: m[1].to_i, name: m[2] }
  end rescue []
end

puts '==================================='
puts '============SOLUTION1=============='
# arr = File.read('data.txt').split("\n")
# puts count_shiny(arr)
puts '==================================='
puts '==================================='
puts '============SOLUTION2=============='


class Day7Test < Test::Unit::TestCase
  def test_1_1
    arr = File.read('data_test.txt').split("\n")
    day7 = Day7.new.for_arr(arr)
    assert_equal 4, day7.flatten_parents('shiny gold').count
  end

  def test_1_final
    arr = File.read('data.txt').split("\n")
    day7 = Day7.new.for_arr(arr)
    assert_equal 4, day7.flatten_parents('shiny gold').count
  end

  def test_2_1
    arr = File.read('data_test.txt').split("\n")
    day7 = Day7.new.for_arr(arr)
    assert_equal 4, day7.flatten_parents('shiny gold').count
  end

  def test_2_2
    arr = File.read('data_test.txt').split("\n")
    day7 = Day7.new.for_arr(arr)
    assert_equal 32, day7.count_strict_child('shiny gold')
  end

  def test_2_3
    arr = File.read('data_test_2.txt').split("\n")
    day7 = Day7.new.for_arr(arr)
    assert_equal 126, day7.count_strict_child('shiny gold')
  end

  def test_2_final
    arr = File.read('data.txt').split("\n")
    day7 = Day7.new.for_arr(arr)
    assert_equal 12128, day7.count_strict_child('shiny gold')
  end

  def test_children
    assert_equal(
      [
        "light red",
        [
          { name: "bright white", num: 1 },
          { name: "muted yellow", num: 2 }
        ]
      ],
      children('light red bags contain 1 bright white bag, 2 muted yellow bags.')
    )
  end
end
