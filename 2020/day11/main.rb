#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'

SQUARE = [
  [-1, -1], [0, -1], [1,  -1],
  [-1,  0],          [1,   0],
  [-1,  1], [0,  1], [1,   1]
]

def loop_until_same(tab, params)
  result = nil
  while (result = next_step(tab, params)) != tab
    tab = result
  end 
  result
end

def next_step(tab, params)
  new_step = tab.dup.map { |it| it.dup }
  tab.each_with_index do |row, j|
    row.each_with_index do |state, i|
      new_step[j][i] = state
      next if state == '.'
      occupied = send("#{params[:method]}", i, j, tab).count {|e| e == '#'}
      new_step[j][i] = '#' if state == 'L' && occupied == 0
      new_step[j][i] = 'L' if state == '#' && occupied >= params[:max]
    end
  end
  new_step
end

def inside_tab?(x, y, tab)
  y.between?(0, tab.length - 1) && x.between?(0, tab[y].length - 1)
end

def neighbour(x, y, tab)
  inside_tab?(x, y, tab) ? tab[y][x] : nil
end

def neighbours(x, y, tab)
  SQUARE.map { |k, l| neighbour(x + k, y + l, tab) }.compact
end

def visible(p, v, tab)
  loop do
    p += v
    break unless inside_tab?(p[0], p[1], tab)
    return tab[p[1]][p[0]] if tab[p[1]][p[0]] != '.'
  end
end

def visibles(x, y, tab)
  SQUARE.map { |vx, vy| visible(Vector[x, y], Vector[vx, vy], tab) }.compact
end


class Day11Test < Test::Unit::TestCase
  def data(name)
    File.read(name).split("\n").map{ |a| a.split(//) }
  end

  def test_visible
    tab = [
      '....2'.chars,
      '..1..'.chars,
      '.....'.chars,
    ]
    assert_equal '2'.chars, visibles(0, 0, tab)
    assert_equal '21'.chars, visibles(1, 0, tab)
    assert_equal '2'.chars, visibles(4, 2, tab)
  end

  def test_neighbours
    tab = [
      '123x'.chars,
      '456x'.chars,
      '789x'.chars,
    ]
    assert_equal '12346789'.chars, neighbours(1, 1, tab)
    assert_equal '245'.chars, neighbours(0, 0, tab)
    assert_equal '12578'.chars, neighbours(0, 1, tab)
    assert_equal '458'.chars, neighbours(0, 2, tab)
    assert_equal '36x'.chars, neighbours(3, 0, tab)
    assert_equal '13456'.chars, neighbours(1, 0, tab)
  end

  def test_star_1_test
    tab = data('data_test.txt')
    tab = loop_until_same(tab, { max: 4, method: :neighbours })
    assert_equal 37, tab.flatten.count{ |c| c == '#' }
  end

  def test_star_2_test
    tab = data('data_test.txt')
    tab = loop_until_same(tab, { max: 5, method: :visibles })
    assert_equal 26, tab.flatten.count{ |c| c == '#' }
  end

  def test_star_1
    tab = data('data.txt')
    tab = loop_until_same(tab, { max: 4, method: :neighbours })
    assert_equal 2303, tab.flatten.count{ |c| c == '#' }
  end

  def test_star_2
    tab = data('data.txt')
    tab = loop_until_same(tab, { max: 5, method: :visibles })
    assert_equal 2057, tab.flatten.count{ |c| c == '#' }
  end
end
