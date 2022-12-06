#!/usr/bin/env ruby
stacks_str, moves_str = File.read("data.txt").split("\n\n")

def extract_stacks(stack)
  stack.split("\n").map do |str|
    str.chars.each_slice(4).map { |arr| arr[1].gsub(/\s+/, "") }
  end[0...-1].transpose.map(&:reverse).map { |arr| arr.reject(&:empty?) }
end

def extract_moves(moves)
  moves.split("\n").map do |str|
    match = str.match(/move (?<num>\d+) from (?<from>\d+) to (?<to>\d+)/)
    { num: match[:num].to_i, from: match[:from].to_i - 1, to: match[:to].to_i - 1 }
  end
end

def section_to_move(stack, move)
  stacks[move[:from]].slice!(-move[:num]..-1)
end

def do_move_9000(stacks, move)
  stacks[move[:to]] += section_to_move(stack, move).reverse
end

def do_move_9001(stacks, move)
  stacks[move[:to]] += section_to_move(stack, move)
end

def move_with(stacks_str, moves, &block)
  stacks = extract_stacks(stacks_str)
  moves.each { |move| block.call(stacks, move) }
  stacks.map { |stack| stack.last }.join("")
end

moves = extract_moves(moves_str)

puts move_with(stacks_str, moves, &method(:do_move_9000))
puts move_with(stacks_str, moves, &method(:do_move_9001))