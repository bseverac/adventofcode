#!/usr/bin/env ruby

arr = File.readlines("data.txt")

def split_string(str)
  str1 = str[0..(str.length / 2 - 1)]
  str2 = str[(str.length / 2)..-1]
  return str1, str2
end

def find_common(arr)
  arr.map(&:chars).reduce(:&).uniq
end

def score(char)
  code = char.codepoints.first
  char == char.downcase ? code - 96 : code - 38
end

def sum_common(arr)
  arr.map do |str|
    str1, str2 = split_string(str)
    score(find_common([str1, str2]).first)
  end.sum
end

def packet3(arr)
  arr.each_slice(3).to_a
end

puts sum_common(arr)
puts packet3(arr).map { |arr| score(find_common(arr).first) }.sum
