#!/usr/bin/env ruby
# frozen_string_literal: true

arr1 = File.readlines('data_1.txt')
arr1 = arr1.map(&:strip).map { _1.split('') }

def extends_all(arr)
  extends_row = extends(arr)
  extends_col = extends(arr.transpose)
  { extends_col:, extends_row: }
end

def extends(arr)
  extends = []
  arr.each_with_index do |row, index|
    extends.push(index) if row.all? { _1 != '#' }
  end
  extends
end

def galaxies_pos(arr)
  galaxies = []
  arr.each_with_index do |row, i|
    row.each_with_index do |c, j|
      galaxies << [i, j] if c == '#'
    end
  end
  galaxies
end

def range(a, b)
  Range.new(*[a, b].minmax)
end

def in_range(arr, range)
  arr.filter { range.include?(_1) }.count
end

def manhathan(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

def distance(a, b, extended, num)
  add_row = in_range(extended[:extends_row], range(a[0], b[0]))
  add_col = in_range(extended[:extends_col], range(a[1], b[1]))
  manhathan(a, b) + (add_row + add_col) * (num - 1)
end

def nearest_galaxy(galaxies, pos)
  galaxies.filter { pos != _1 }.map { |g| distance(g, pos) }.min
end

extended = extends_all(arr1)
galaxies = galaxies_pos(arr1)

# stars 1
puts galaxies.combination(2).map { distance(_1, _2, extended, 2) }.sum
# stars 2
puts galaxies.combination(2).map { distance(_1, _2, extended, 1_000_000) }.sum
