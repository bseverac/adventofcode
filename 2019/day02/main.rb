#!/usr/bin/env ruby
require 'test/unit'
extend Test::Unit::Assertions

def play_step(memory, cursor = 0)
  case memory[cursor]
  when 1
    operator(memory, cursor, :+)
  when 2
    operator(memory, cursor, :*)
  when 99
    memory
  else
    raise "#{memory[cursor]} is not a fonction"
  end
end

def operator(memory, cursor, operation)
  left_value = p_value(memory, cursor + 1)
  right_value = p_value(memory, cursor + 2)
  result_index = value(memory, cursor + 3)
  memory[result_index] = left_value.send(operation, right_value)
  play_step(memory, cursor + 4)
end

def p_value(memory, cursor) #pointer_value
  memory[memory[cursor]]
end

def value(memory, cursor)
  memory[cursor]
end

arr = File.readlines('data.txt')
init_memory = arr.join.split(',').map(&:to_i)

puts '==================================='
puts '============SOLUTION1=============='
memory = init_memory.dup
memory[1] = 12
memory[2] = 2
puts play_step(memory)[0]
puts '==================================='
puts '==================================='
puts '============SOLUTION1=============='
(0..99).each do |noun|
  (0..99).each do |verb|
    memory = init_memory.dup
    memory[1] = noun
    memory[2] = verb
    if play_step(memory)[0] == 19690720
      signature = "100 * #{noun} + #{verb}"
      puts "#{signature} = #{eval(signature)}"
    end
  end
end
puts '==================================='

## Tests
class Day2 < Test::Unit::TestCase
  def test_plus
    assert_equal [2,0,0,0,99], play_step([1,0,0,0,99])
    assert_equal [2,3,0,6,99], play_step([2,3,0,3,99])
    assert_equal [2,4,4,5,99,9801], play_step([2,4,4,5,99,0])
    assert_equal [30,1,1,4,2,5,6,0,99], play_step([1,1,1,4,99,5,6,0,99])
  end
end
