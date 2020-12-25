#!/usr/bin/ruby
require 'matrix'
require 'test/unit'
require 'pry'

class Day17
  attr_accessor :cells

  def initialize(grid, d)
    @d = d
    @cells = {}
    grid.split("\n").each.with_index { |line, y|
      line.split(//).each.with_index.select{ |c, _| c == '#'}.each  { |_, x|
        self.add_cell(([0] * @d).zip([x, y]).map(&:compact).map(&:sum))
      }
    }
  end

  def step
    @cells = cells_to_evaluate.each_with_object({}) do |c, cells|
      cells[c] = true if activated?(c)
    end
  end

  def activated?(c)
    (@cells[c] && (2..3).include?(closed_active(c))) ||
    (!@cells[c] && closed_active(c) == 3)
  end

  def cells_to_evaluate
    @cells.map { |c, _| closed_cells(c) + [c] }.flatten(1).uniq
  end

  def add_cell(c)
    @cells[c] = true
  end

  def closed_cells(c)
    [1, 0, -1].repeated_permutation(@d).reject { |c| c == [0] * @d }.map{ |ac|
      c.zip(ac).map(&:sum)
    }
  end

  def closed_active(c)
    closed_cells(c).count { |c| @cells[c] }
  end
end

#start 20:40
#end   22:10
class Day17Test < Test::Unit::TestCase
  def test_star_1
    solver = Day17.new(File.read('data_test.txt'), 3)
    6.times { |_| solver.step }
    assert_equal 112, solver.cells.count
  end

  def test_star_1_final
    solver = Day17.new(File.read('data.txt'), 3)
    6.times { |_| solver.step }
    assert_equal 230, solver.cells.count
  end

  def test_star_2
    solver = Day17.new(File.read('data_test.txt'), 4)
    6.times { |_| solver.step }
    assert_equal 848, solver.cells.count
  end

  def test_star_2_final
    solver = Day17.new(File.read('data.txt'), 4)
    6.times { |_| solver.step }
    assert_equal 1600, solver.cells.count
  end
end
