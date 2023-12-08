#!/usr/bin/env ruby
# frozen_string_literal: true

string = File.read('data_1.txt')
string = string.strip

def calcul(total_time, waiting_time)
  return 0 if total_time <= waiting_time

  (total_time - waiting_time) * waiting_time
end

def min_time_to_win(total_time, min_distance)
  result = (0..(total_time / 2)).bsearch do |waiting_time|
    calcul(total_time, waiting_time) > min_distance
  end
  (total_time / 2 - result) * 2 + (total_time.odd? ? 2 : 1)
end

# stars1
times = string[/Time: (.*)\n/, 1].split(' ').map(&:to_i)
distances = string[/Distance: (.*)/, 1].split(' ').map(&:to_i)
puts distances.map.with_index { min_time_to_win(times[_2], distances[_2]) }.reduce(:*)
# stars2
time = string[/Time: (.*)\n/, 1].gsub(' ', '').to_i
distance = string[/Distance: (.*)/, 1].gsub(' ', '').to_i
puts min_time_to_win(time, distance)
