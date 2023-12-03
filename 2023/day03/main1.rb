#!/usr/bin/env ruby
# frozen_string_literal: true

arr1 = File.readlines('data_1.txt')
arr1 = arr1.map(&:strip)

SQUARE = [
  [-1, -1], [0, -1], [1, -1],
  [-1,  0],          [1, 0],
  [-1,  1], [0, 1], [1, 1]
].freeze

def inside_arr?(x, y, arr)
  y.between?(0, arr.length - 1) && x.between?(0, arr[y].length - 1)
end

def neighbour(x, y, arr)
  inside_arr?(x, y, arr) ? { x:, y:, value: arr[y][x] } : nil
end

def neighbours(x, y, arr)
  SQUARE.map { |k, l| neighbour(x + k, y + l, arr) }.compact
end

# stars 1
class Stars1
  def initialize(arr)
    @arr = arr
    @current_str = ''
    @neighbours = []
    @result = 0
  end

  def call
    @arr.each_with_index do |row, j|
      row.each_char.with_index do |state, i|
        update_current(state, i, j)
        check_current(row, state, i, j)
      end
    end
    @result
  end

  def update_current(state, i, j)
    return unless state[/\d/]

    @current_str += state
    @neighbours += neighbours(i, j, @arr)
  end

  def check_current(row, state, i, _j)
    return unless @current_str.length.positive? && (row[i + 1].nil? || !state[/\d/])

    @result += @current_str.to_i if @neighbours.any? { |v| v[:value][/[^\d.]/] }
    @current_str = ''
    @neighbours = []
  end
end

# stars 2
class Stars2
  def initialize(arr)
    @arr = arr
    @current_str = ''
    @neighbours = []
    @gears = {}
  end

  def call
    loop
    @gears.filter { |_, v| v.length == 2 }.map { |_, v| v.reduce(&:*) }.sum
  end

  def loop
    @arr.each_with_index do |row, j|
      row.each_char.with_index do |state, i|
        update_current(state, i, j)
        check_current(row, state, i, j)
      end
    end
  end

  def update_current(state, i, j)
    return unless state[/\d/]

    @current_str += state
    @neighbours += neighbours(i, j, @arr)
  end

  def check_current(row, state, i, _j)
    return unless @current_str.length.positive? && (row[i + 1].nil? || !state[/\d/])

    update_gears
    @current_str = ''
    @neighbours = []
  end

  def update_gears
    @neighbours.filter { |v| v[:value] == '*' }.uniq { |v| "#{v[:x]}_#{v[:y]}" }.each do |gear|
      uniq_id = "#{gear[:x]}_#{gear[:y]}"
      @gears[uniq_id] = [] unless @gears[uniq_id]
      @gears[uniq_id] << @current_str.to_i
    end
  end
end

puts Stars1.new(arr1).call
puts Stars2.new(arr1).call
