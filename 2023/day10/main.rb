#!/usr/bin/env ruby
# frozen_string_literal: true

arr1 = File.readlines('data_1.txt')
arr1 = arr1.map(&:strip).map { _1.split('') }

def starting_point(arr)
  arr.each_with_index { |row, i| return [i, row.index('S')] if row.include?('S') }
end

class String
  def red = "\e[31m#{self}\e[0m"
  def green = "\e[32m#{self}\e[0m"
end

def display(arr, in_path, inside = {})
  arr.each_with_index do |row, i|
    puts row.map.with_index { |c, j|
           if in_path[[i, j]]
             c.red
           else
             inside[[i, j]] ? c.green : c
           end
         }.join('')
  end
end

DIRECTIONS = {
  'N' => [-1, 0],
  'S' => [1, 0],
  'E' => [0, 1],
  'W' => [0, -1]
}.freeze

MOVING = {
  '|' => %w[N S],
  '-' => %w[E W],
  'L' => %w[N E],
  'J' => %w[N W],
  '7' => %w[S W],
  'F' => %w[S E]
}.freeze

def directions(cell)
  MOVING[cell].map { DIRECTIONS[_1] }
end

def moveable_cells(arr, pos, in_path)
  cell = arr[pos[0]][pos[1]]
  directions(cell).map { |d| [pos[0] + d[0], pos[1] + d[1]] }.select { in_path[_1].nil? }
end

def move_loop(arr, pos, in_path)
  steps = 0
  while go_to = moveable_cells(arr, pos, in_path).first
    in_path[pos] = true
    pos = go_to
    steps += 1
  end
  steps + 1
end

starting_point = starting_point(arr1)
arr1[starting_point[0]][starting_point[1]] = '|'
in_path = {}
inside = {}
puts move_loop(arr1, starting_point, in_path) / 2

arr1.each_with_index do |row, i|
  row.each_with_index do |_cell, j|
    next if in_path[[i, j]]

    elements = row[..j].reject.with_index { !in_path[[i, _2]] }.join('').gsub(/LJ|F7|-/, '').gsub(/L7|FJ/, '|')
    inside[[i, j]] = true if elements.chars.count.odd?
  end
end

display(arr1, in_path, inside)
puts inside.keys.count
