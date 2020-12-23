#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'
require 'digest'

class Game
  def initialize(init)
    @nums = init.split(//).map(&:to_i)
    @cur = create_list(@nums)
  end

  def resolve_1(start)
    r = []
    cur = start
    while @cups[cur][:next][:num] != start
      r << @cups[cur][:next][:num]
      cur = @cups[cur][:next][:num]
    end
    r.join
  end

  def step(n)
    n.times do |i|
      puts "--- move #{i + 1} ---" if i % 500_000 == 0
      @keeps = [
        @cur[:next], @cur[:next][:next], @cur[:next][:next][:next]
      ]
      @cur[:next] = @keeps.last[:next]
      dest = find_dest
      @keeps.last[:next] = dest[:next]
      dest[:next] = @keeps.first
      @cur = @cur[:next]
    end
    [@cups[1][:next][:num], @cups[1][:next][:next][:num]]
  end

  def find_dest
    keep_nums = @keeps.map{|k| k[:num]}
    target = @cur[:num] - 1
    target -= 1 while keep_nums.include?(target) && target != 0
    target = @cups[-1][:num] if target == 0
    target -= 1 while keep_nums.include?(target)
    @cups[target]
  end

  def complete_circle
    range = ((@nums.max + 1)..1_000_000).to_a
    create_list(range)
    @cups[@nums.last][:next] = @cups[range.first]
    @cups[range.last][:next] = @cups[@nums.first]
  end

  def create_list(arr)
    @cups ||= []
    @cups[arr.first] = cur = { num: arr.first, next: nil }
    nxt = cur
    arr[1..-1].reverse.each do |num|
      nxt = @cups[num] = { num: num, next: nxt }
    end
    cur[:next] = @cups[arr[1]]
    cur
  end
end

class Day22Test < Test::Unit::TestCase
  def test_star_1
    game = Game.new('389125467')
    game.step(10)
    assert_equal '92658374', game.resolve_1(1)
  end

  def test_star_1_final
     game = Game.new('318946572')
     game.step(100)
     assert_equal '52864379', game.resolve_1(1)
  end

  def test_star_2
    game = Game.new('389125467')
    game.complete_circle
    assert_equal 149245887792, game.step(10_000_000).inject(&:*)
  end

  def test_star_2_final
    game = Game.new('318946572')
    game.complete_circle
    assert_equal 11591415792, game.step(10_000_000).inject(&:*)
  end
end
