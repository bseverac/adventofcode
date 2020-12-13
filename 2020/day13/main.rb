#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'

def extract_data(name)
  data = File.read(name).split("\n")
  [data[0].to_i, data[1].split(',').map(&:to_i)]
end

def resolve_1(data)
  data[1].reject { |e| e == 0 }.inject({ id: nil, time: Float::INFINITY }) { |h, id|
    time = - (data[0] % id) + id
    time < h[:time] ? { id: id, time: time, result: id * time } : h
  }[:result]
end

def resolve_2(data)
  result = { first: 0, period: 1 }
  data[1].each_with_index do |v, delta|
    result = find_pair_match(result, v, delta)
  end
  result[:first]
end

def find_pair_match(result, b, offset)
  return result if b == 0 # 'x'
  a = result[:period]
  time = result[:first]
  while (time + offset) % b != 0
    time += result[:period]
  end
  { first: time, period: a * b }
end

class Day12Test < Test::Unit::TestCase
  def test_star_1
    data = extract_data('data_test.txt')
    assert_equal 295, resolve_1(data)
  end

  def test_star_1_final
    data = extract_data('data.txt')
    assert_equal 4808, resolve_1(data)
  end

  def test_star_2
    data = extract_data('data_test.txt')
    assert_equal 1068781, resolve_2(data)
  end

  def test_star_2_final
    data = extract_data('data.txt')
    assert_equal 741745043105674, resolve_2(data)
  end
end
