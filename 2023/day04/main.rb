#!/usr/bin/env ruby
# frozen_string_literal: true

arr1 = File.readlines('data_1.txt')
arr1 = arr1.map(&:strip)

card_score = arr1.map { |e| e.match(/Card *\d*: (.*) \| (.*)/).captures }.map do |e|
  e[0].split.map(&:to_i).intersection(e[1].split.map(&:to_i)).count
end

# stars1
puts card_score.filter(&:positive?).map { |e| 2.pow(e - 1) }.sum

# stars2
copies = {}
card_score.map.with_index do |e, index|
  copies[index] ||= 1
  e.times do |i|
    copies[index + i + 1] ||= 1
    copies[index + i + 1] += copies[index]
  end
end

puts copies.values.sum
