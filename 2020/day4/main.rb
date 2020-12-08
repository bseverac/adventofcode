#!/usr/bin/ruby
require 'test/unit'
require 'pry'

extend Test::Unit::Assertions

def str_to_h(str)
  Hash[*str.split(/[ :\n]/)]
end

def height_valid(str)
  m = str.match(/^(?<val>\d{1,})(?<unit>in|cm)$/)
  return false unless m
  (m[:unit] == 'cm' ? 150..193 : 59..76).include? m[:val].to_i
end

def is_valid_1(hash)
  (%w[byr iyr eyr hgt hcl ecl pid] - hash.keys).count.zero?
end

def is_valid_2(hash)
  is_valid_1(hash) &&
  (1920..2002).include?(hash['byr'].to_i) &&
  (2010..2020).include?(hash['iyr'].to_i) &&
  (2020..2030).include?(hash['eyr'].to_i) &&
  height_valid(hash['hgt']) &&
  hash['hcl'].match?(/^#[\da-f]{6}$/) &&
  %w[amb blu brn gry grn hzl oth].include?(hash['ecl']) &&
  hash['pid'].match?(/^[\d]{9}$/)
end

puts '==================================='
arr = File.readlines('data.txt').join.split("\n\n")
puts '============SOLUTION1=============='

puts arr.select { |str| is_valid_1(str_to_h(str)) }.count
puts '==================================='
puts '==================================='
puts '============SOLUTION2=============='
puts arr.select { |str| is_valid_2(str_to_h(str)) }.count
## Tests

class Day4 < Test::Unit::TestCase
  def test_plus
    assert_equal(
      { 'key1' => 'value1', 'key2' => 'value2' },
      str_to_h('key1:value1 key2:value2')
    )
  end

  def test_validity
    assert(
      is_valid_1(
        str_to_h(
          "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd byr:1937 iyr:2017 cid:147 hgt:183cm"
         )
       )
    )
    refute(
      is_valid_1(
        str_to_h(
          "hcl:#cfa07d eyr:2025 pid:166559648\niyr:2011 ecl:brn hgt:59in"
         )
       )
    )
  end
  def test_validity_2
    hash = str_to_h("pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f")
    assert(is_valid_2(hash))
  end
end
