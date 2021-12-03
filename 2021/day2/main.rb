#!/usr/bin/env ruby
arr = File.readlines('data.txt')

aim, depth, position = 0, 0, 0

arr.each do |line|
  match = line.match(/(?<cmd>\w+) (?<x>\d+)/)
  x, cmd = [match[:x].to_i, match[:cmd]]
  depth += x if cmd == 'down'
  depth -= x if cmd == 'up'
  position += x if cmd == 'forward'
end
puts depth * position #1250395

aim, depth, position = 0, 0, 0

arr.each do |line|
  match = line.match(/(?<cmd>\w+) (?<x>\d+)/)
  x, cmd = [match[:x].to_i, match[:cmd]]
  aim += x if cmd == 'down'
  aim -= x if cmd == 'up'
  if cmd == 'forward'
    position += x 
    depth += x * aim
  end
end
puts depth * position # 1451210346