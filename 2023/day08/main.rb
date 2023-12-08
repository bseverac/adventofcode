#!/usr/bin/env ruby
# frozen_string_literal: true

arr1 = File.readlines('data_1.txt')
arr1 = arr1.map(&:strip)
instructions = arr1[0]
dict = arr1[2..].each_with_object({}) do |line, dict|
  cell, left, right = line.match(/(.*) = \((.*), (.*)\)/).captures
  dict[cell] = { L: left, R: right }
end

def move(current, dict, instructions)
  instruction = instructions[current[:total] % instructions.size]
  current[:pos] = dict[current[:pos]][instruction.to_sym]
  current[:total] += 1
end

def move_all(currents, dict, instructions)
  currents.reject { _1[:pos].end_with?('Z') }.each do |current|
    move(current, dict, instructions)
  end
end

# stars1
current = { pos: 'AAA', total: 0 }
move(current, dict, instructions) while current[:pos] != 'ZZZ'
puts current[:total]

# stars2
currents = dict.keys.select { |k| k.end_with?('A') }.map { |k| { pos: k, total: 0 } }
move_all(currents, dict, instructions) while currents.any? { |current| !current[:pos].end_with?('Z') }
puts currents.map { _1[:total] }.inject(:lcm)
