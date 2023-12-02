#!/usr/bin/env ruby
# frozen_string_literal: true

arr1 = File.readlines('data_1.txt')
arr2 = File.readlines('data_2.txt')

NUMBERS = %w[one two three four five six seven eight nine].freeze

def string_to_number(str)
  index = NUMBERS.find_index(str)
  index ? index + 1 : str.to_i
end

def first_and_last(arr, regexp = /\d/)
  arr.map do
    first = _1[/#{regexp}/]
    last = _1[/.*(#{regexp}).*/, 1]
    string_to_number(first) * 10 + string_to_number(last)
  end
end

puts first_and_last(arr1).sum
puts first_and_last(arr2, /\d|#{NUMBERS.join('|')}/).sum
