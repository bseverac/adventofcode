#!/usr/bin/env ruby
arr = File.readlines("data.txt")

SYMBOLS = ["A", "B", "C"]

def convert(str)
  (str.codepoints.first - 23).chr
end

def lose_against(str)
  SYMBOLS[(SYMBOLS.find_index(str) - 1) % SYMBOLS.length]
end

def win_against(str)
  SYMBOLS[(SYMBOLS.find_index(str) + 1) % SYMBOLS.length]
end

def shape_score(shape)
  shape.codepoints.first - 64
end

def result_score(opp, me)
  return 6 if me == win_against(opp)
  return 3 if me == opp
  0
end

def score_stars_1(str)
  opp, me = str.split(" ")
  me = convert(me)
  score = shape_score(me) + result_score(opp, me)
end

def score_stars_2(str)
  opp, result = str.split(" ")
  me = lose_against(opp) if result == "X"
  me = opp if result == "Y"
  me = win_against(opp) if result == "Z"
  score = shape_score(me) + result_score(opp, me)
end

def total_score_stars_1(arr)
  arr.map { |str| score_stars_1(str) }.sum
end

def total_score_stars_2(arr)
  arr.map { |str| score_stars_2(str) }.sum
end

puts total_score_stars_1(arr)
puts total_score_stars_2(arr)
