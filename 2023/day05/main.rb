#!/usr/bin/env ruby
# frozen_string_literal: true

string = File.read('data_1.txt')
string = string.strip

def extract_seeds(string)
  string[/seeds: (.*)/, 1].split(' ').map(&:to_i)
end

def extract_map(string)
  arr = string.split("\n").map { |line| line.split(' ').map(&:to_i) }
  arr.map { |dest, target, range| { target:, dest:, range:, target_max: target + range } }
end

def extract_maps(string)
  string.scan(/(\w*)-to-(\w*) map:\n([\s\d]*)/).map do |map|
    { from: map[0], to: map[1], rules: extract_map(map[2]) }
  end.compact
end

def transpose(element, rules)
  match = rules.find do |rule|
    (rule[:target]..(rule[:target_max])).include?(element)
  end
  match ? element + (match[:dest] - match[:target]) : element
end

def split_ranges(range, rules)
  rules.each do |rule|
    ranges = split_range(range, rule)
    return ranges.map { |r| split_ranges(r, rules) }.flatten if ranges.count > 1
  end.flatten.compact
  [range]
end
# rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

def split_range(range, rule)
  if range.min < rule[:target] && rule[:target_max] < range.max
    [range.min..(rule[:target] - 1), (rule[:target]..rule[:target_max]), ((rule[:target_max] + 1)..range.max)]
  elsif range.min >= rule[:target] && rule[:target_max] >= range.max
    [range]
  elsif range.min < rule[:target] && range.max < rule[:target_max] && range.max > rule[:target]
    [range.min..(rule[:target] - 1), ((rule[:target])..range.max)]
  elsif range.min > rule[:target] && range.max > rule[:target_max] && range.min < rule[:target_max]
    [range.min..(rule[:target_max]), (rule[:target_max] + 1)..range.max]
  else
    [range]
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

seeds = extract_seeds(string)
maps = extract_maps(string)
stars1 = seeds

stars2 = seeds.each_slice(2).map { |a, b| a..(a + b) }

maps.each do |map|
  puts map
  puts stars2
  stars2 = stars2.map { |q| split_ranges(q, map[:rules]) }.flatten

  stars2 = stars2.map do |a|
             [a.first, a.last]
           end.flatten.map { |a| transpose(a, map[:rules]) }.each_slice(2).map { |a, b| a..b }
end
puts stars2.map { |a| a.min }.min - 1 # why -1?

# solution 20283860
