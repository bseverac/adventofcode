#!/usr/bin/env ruby
# frozen_string_literal: true

arr1 = File.readlines('data_1.txt')

MAXIMUNS = { red: 12, green: 13, blue: 14 }.freeze

def match_filter?(set)
  MAXIMUNS.keys.all? do |color|
    (set[color] || 0) <= MAXIMUNS[color]
  end
end

def game_match_filter?(game)
  game[:sets].all? { match_filter? _1 }
end

def maximun_colors(game)
  { red: 0, green: 0, blue: 0 }.tap do |hash|
    game[:sets].each { |set| set.each { |color, num| hash[color] = num if num > hash[color] } }
  end
end

def min_power(game)
  maximun_colors(game).values.reduce(:*)
end

def game_to_hash(str)
  sets = str[/Game \d+: (.*)$/, 1].split('; ').map do |i|
    i.split(', ').map do |color|
      num, color = color.split(' ')
      [color.to_sym, num.to_i]
    end.to_h
  end
  { id: str[/Game (\d+)/, 1].to_i, sets: }
end

games = arr1.map { game_to_hash _1 }
# stars 1
puts games.filter { game_match_filter? _1 }.sum { _1[:id] }
# stars 2
puts games.map { min_power _1 }.sum
