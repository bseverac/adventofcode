#!/usr/bin/env ruby
arr_1 = File.readlines("data_1.txt")
arr_2 = File.readlines("data_2.txt")

NUMBERS = %w[one two three four five six seven eight nine]

def string_to_number(str)
    index = NUMBERS.find_index(str)
    index ? index + 1 : str.to_i
end

def first_and_last arr, regexp = /\d/
    arr.map do
        first = _1[/#{regexp}/]
        last = _1[/.*(#{regexp}).*/, 1]
        string_to_number(first) * 10 + string_to_number(last)
    end
end

puts first_and_last(arr_1).sum
puts first_and_last(arr_2, /\d|#{NUMBERS.join('|')}/).sum
