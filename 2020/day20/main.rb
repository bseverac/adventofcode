#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'

class Tile
  class << self
    attr_accessor :tiles, :grid
  end

  attr_accessor :id, :locked, :lines
  def initialize(data)
    @title, @map = data.split(":\n")
    _, @id = @title.split(' ')
    @id = @id.to_i
    @lines = @map.split("\n")
    @locked = false
  end

  def borders
    @borders ||= [
      @lines.first,
      @lines.map {|l| l[-1]}.join,
      @lines.last,
      @lines.map {|l| l[0]}.join
    ]
  end

  def display
    puts @lines.join("\n")
  end
  
  def inside
    @lines[1..-2].map{ |a| a[1..-2]}
  end

  def match?(tile)
    return false if tile.id == @id
    borders.any? { |border| match_border?(tile, border) }
  end

  def match_border?(tile, border)
    (tile.borders - [border, border.reverse]).count != 4
  end

  def neighbours
    @neighbours ||= Tile.tiles.select { |tile| match?(tile) }
  end

  def is_corner?
    neighbours.count == 2
  end

  def position(x, y)
    Tile.grid ||= []
    Tile.grid[y] ||= []
    Tile.grid[y][x] = self
  end

  def turn_neighbours
    4.times { |_| 
      rotate if !neighbour(2) || !neighbour(1)
      reverse if !neighbour(2) || !neighbour(1)
      reverse if !neighbour(2) || !neighbour(1)
    }

    rotate_left_neighbours(0,0)
    rotate_bottom_neighbours(0,0)
  end

  def rotate_left_neighbours(x, y)
    position(x, y)
    cell = rotate_to_match(1, 3)
    cell&.rotate_left_neighbours(x + 1, y)
  end

  def rotate_bottom_neighbours(x, y)
    position(x, y)
    cell = rotate_to_match(2, 0)
    cell&.rotate_left_neighbours(x, y + 1)
    cell&.rotate_bottom_neighbours(x, y + 1)
  end

  def rotate_to_match(index1, index2)
    return unless cell ||= neighbour(index1)
    return if cell.locked
    4.times { |_| 
      cell.rotate if cell.borders[index2] != borders[index1]
      cell.reverse if cell.borders[index2] != borders[index1]
      cell.reverse if cell.borders[index2] != borders[index1]
    }
    cell.borders[index2] == borders[index1] ? cell.locked! : nil
  end

  def neighbour(index)
    neighbours.find { |tile| match_border?(tile, borders[index]) }
  end

  def rotate
    @lines = @lines.map{|l| l.split(//)}.transpose.map(&:reverse).map(&:join)
    @borders = nil
  end

  def reverse
    @lines = @lines.reverse
    @borders = nil
  end

  def locked!
    @locked = true
    self
  end

  def self.merge
    Tile.grid.map do |line|
      line[1..-1].inject(line[0].inside) do |a, cell|
        a.zip(cell.inside).map {|a| a.join }
      end
    end.flatten
  end

  def self.roughness
    arr = Tile.merge
    4.times do |_| 
      arr = arr.map{|l| l.split(//)}.transpose.map(&:reverse).map(&:join) if monster_count(arr) == 0
      arr = arr.reverse if monster_count(arr) == 0
      arr = arr.reverse if monster_count(arr) == 0
    end
    return arr.join.scan(/#/).length - 15 * monster_count(arr)
  end

  def self.monster_count(arr)
    regexp =  ['#.', '#....##....##....###', '.#..#..#..#..#..#'].join('.' * (arr.length - 20))
    str = arr.join
    str.chars.each.with_index.count { |_, i| str[i..-1].start_with?(Regexp.new(regexp)) }
  end

  def self.display_id
    puts Tile.grid.map{|a| a.map(&:id).join(' ')}.join("\n")
  end
end

def extract_tiles(name)
  Tile.tiles = File.read(name).split("\n\n").map do |data|
    Tile.new(data)
  end
end

class Day20Test < Test::Unit::TestCase
  def test_star_1
    tiles = extract_tiles('data_test.txt')
    assert_equal 20899048083289, tiles.select { |tile| tile.is_corner? }.map(&:id).inject(&:*)
  end

  def test_star_1_final
    tiles = extract_tiles('data.txt')
    assert_equal 18482479935793, tiles.select { |tile| tile.is_corner? }.map(&:id).inject(&:*)
  end

  def test_star_2
    tiles = extract_tiles('data_test.txt')
    tiles.select {|tile| tile.is_corner? }.last.turn_neighbours
    assert_equal 273, Tile.roughness
  end

  def test_star_2_final
    tiles = extract_tiles('data.txt')
    tiles.select {|tile| tile.is_corner? }.first.turn_neighbours
    assert_equal 2118, Tile.roughness
  end
end
