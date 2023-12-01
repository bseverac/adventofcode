#!/usr/bin/env ruby
arr = File.readlines("data.txt")

def or_operation(arr1, arr2)
  arr1.map.with_index { |e, i| e || arr2[i] }
end

def visible_trees(arr)
  current_max_height = -1
  visibility = []
  arr.map do |e|
    visible = e > current_max_height
    current_max_height = e if e > current_max_height
    visible
  end
end

class Grid
  def initialize(arr)
    @grid = arr.map(&:strip).map { |e| e.split("").map { |c| c.to_i } }
    @visibility_grid = @grid.map { |row| row.map { false } }
    @scenic_score_grid = @grid.map { |row| row.map { 0 } }
    visibility_grid
    scenic_score_grid
  end

  def visibility_grid
    current_max_height = 0
    @grid.each_with_index do |row, i|
      @visibility_grid[i] = or_operation(@visibility_grid[i], visible_trees(row))
      @visibility_grid[i] = or_operation(@visibility_grid[i], visible_trees(row.reverse).reverse)
    end
    @visibility_grid = @visibility_grid.transpose
    @grid.transpose.each_with_index do |row, i|
      @visibility_grid[i] = or_operation(@visibility_grid[i], visible_trees(row))
      @visibility_grid[i] = or_operation(@visibility_grid[i], visible_trees(row.reverse).reverse)
    end
    @visibility_grid = @visibility_grid.transpose
    @grid.transpose
  end

  def scenic_score_grid
    @grid.each_with_index do |row, i|
      row.each_with_index do |_, j|
        @scenic_score_grid[i][j] = scenic_score(i, j)
      end
    end
  end

  def scenic_score(i, j)
    scenic_score_on(i, j, 1, 0) *
    scenic_score_on(i, j, -1, 0) *
    scenic_score_on(i, j, 0, 1) *
    scenic_score_on(i, j, 0, -1)
  end

  def scenic_score_on(i, j, dir_x, dir_y)
    height = @grid[i][j]
    score = 0
    loop do
      i = i + dir_x
      j = j + dir_y
      break unless i >= 0 && j >= 0 && @grid[i] && @grid[i][j]
      score += 1
      break if @grid[i][j] >= height
    end
    score
  end

  def display_visibility
    @visibility_grid.each { |e| puts e.map { |e| e ? "#" : "." }.join("") }
  end

  def num_of_visible_trees
    @visibility_grid.sum { |e| e.count(true) }
  end

  def display_scenic_score
    @scenic_score_grid.each { |e| puts e.join(" ") }
  end

  def max_scenic_score
    @scenic_score_grid.flatten.max
  end
end

grid = Grid.new(arr)

#star 1
grid.display_visibility
puts grid.num_of_visible_trees

#star 2
grid.display_scenic_score
puts grid.max_scenic_score
