#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'

def extract_data(name)
  File.read(name).split("\n")
end

class Day12
  def initialize
    @mask = ''
    @memory = {}
  end

  def play(line, star='*')
    action, value = line.split(' = ')
    if action == 'mask'
      @mask = value
    else
      adr = action.split(/[\[\]]/)[1].to_i
      if star == '*'
        @memory[adr] = (value.to_i | mask_for(@mask, '0')) & mask_for(@mask, '1')
      elsif star == '**'
        adr |= mask_for(@mask, '1')
        adr = ("%036b" % adr).each_char.each_with_index.map { |chr, i| @mask[i] == 'X' ? 'X' : chr }.join
        x_count = @mask.count('X')
        (2 ** x_count).times do |num|
          adr_x = adr.split(/X/, -1).zip(("%0#{x_count}b" % num).split(//)).flatten.join('')
          @memory[adr_x] = value.to_i
        end
      end
    end
  end

  def mask_for(mask, bin)
    mask.gsub('X', bin).to_i(2)
  end

  def sum
    @memory.values.sum
  end
end


class Day12Test < Test::Unit::TestCase
  def test_star_1
    d = Day12.new
    assert_equal(
      73,
      d.exec_mask(
        'XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X',
        11
      )
    )
  end

  def test_star_1_test
    data = extract_data('data_test.txt')
    d = Day12.new
    data.each { |line| d.play(line, "*") }
    assert_equal 165, d.sum
  end

  def test_star_1
    data = extract_data('data.txt')
    d = Day12.new
    data.each { |line| d.play(line, "*") }
    assert_equal 4297467072083, d.sum
  end

  def test_star_2
    data = extract_data('data_test2.txt')
    d = Day12.new
    data.each { |line| d.play(line, "**") }
    assert_equal 208, d.sum
  end

  def test_star_2_final
    data = extract_data('data.txt')
    d = Day12.new
    data.each { |line| d.play(line, "**") }
    assert_equal 5030603328768, d.sum
  end
end
