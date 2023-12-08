#!/usr/bin/env ruby
# frozen_string_literal: true

arr1 = File.readlines('data_1.txt')
arr1 = arr1.map(&:strip)

POINT_1 = %w[2 3 4 5 6 7 8 9 T J Q K A].each.with_index.to_h
POINT_2 = %w[J 2 3 4 5 6 7 8 9 T Q K A].each.with_index.to_h

def uniq_hand(hand)
  hand.chars.each_with_object(Hash.new(0)) { |e, h| h[e] += 1 }
end

def highest?(target, source, point)
  5.times do |i|
    return point[target[i]] > point[source[i]] if target[i] != source[i]
  end
end

def highest_card?(uniq_hand)
  uniq_hand.values.count == 5
end

def one_pair?(uniq_hand)
  uniq_hand.values.max == 2
end

def two_pairs?(uniq_hand)
  uniq_hand.values.sort == [1, 2, 2]
end

def three_of_a_kind?(uniq_hand)
  uniq_hand.values.include?(3)
end

def full_house?(uniq_hand)
  uniq_hand.values.include?(3) && uniq_hand.values.include?(2)
end

def four_of_a_kind?(uniq_hand)
  uniq_hand.values.max == 4
end

def five_of_a_kind?(uniq_hand)
  uniq_hand.values.max == 5
end

def rank(hand)
  6 - %i[five_of_a_kind? four_of_a_kind? full_house? three_of_a_kind? two_pairs? one_pair?
         highest_card?].find_index do |r|
        send(r, hand)
      end
end

def transfert_joker!(uniq_hand)
  max_key = uniq_hand.max_by { |k, v| k != 'J' ? v : 0 }[0]
  return uniq_hand if max_key == 'J'

  uniq_hand[max_key] += uniq_hand['J']
  uniq_hand.delete('J')
  uniq_hand
end

arr1.map! do |line|
  hand, bid = line.split(' ')
  {
    hand:,
    bid: bid.to_i,
    rank1: rank(uniq_hand(hand)),
    rank2: rank(transfert_joker!(uniq_hand(hand)))
  }
end

def sort_arr(a, b, r, point)
  if a[r] == b[r]
    highest?(a[:hand], b[:hand], point) ? 1 : -1
  else
    a[r] <=> b[r]
  end
end

def sum_score(arr, rank, point)
  arr.sort { |a, b| sort_arr(a, b, rank, point) }.map.with_index.map { |e, i| e[:bid] * (i + 1) }.sum
end

pp sum_score(arr1, :rank1, POINT_1)
pp sum_score(arr1, :rank2, POINT_2)
