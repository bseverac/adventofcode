#!/usr/bin/env ruby
arr = File.readlines("data.txt")

class Grid
  def initialize(num = 2, debug)
    @num = num
    @debug = debug
    @grid_min_x, @grid_max_x, @grid_min_y, @grid_max_y = 0, 0, 0, 0
    @knots_x = Array.new(num, 0)
    @knots_y = Array.new(num, 0)

    @visited = {}
    move_to(0, 0)
  end

  def move_to(x, y)
    @grid_min_x = [@grid_min_x, x].min
    @grid_max_x = [@grid_max_x, x].max
    @grid_min_y = [@grid_min_y, y].min
    @grid_max_y = [@grid_max_y, y].max
    @knots_x[0] = x
    @knots_y[0] = y
    move_tails
  end

  def action(direction, distance)
    distance.times do
      case direction
      when "R"
        move_to(@knots_x[0] + 1, @knots_y[0])
      when "L"
        move_to(@knots_x[0] - 1, @knots_y[0])
      when "U"
        move_to(@knots_x[0], @knots_y[0] - 1)
      when "D"
        move_to(@knots_x[0], @knots_y[0] + 1)
      end
    end
    print_visited
  end

  def need_move_tail?(num)
    abs_x(num) > 1 || abs_y(num) > 1
  end

  def abs_x(num)
    (@knots_x[num - 1] - @knots_x[num]).abs
  end

  def abs_y(num)
    (@knots_y[num - 1] - @knots_y[num]).abs
  end

  def move_tails
    @num.times do |i|
      if i != 0 && need_move_tail?(i)
        if @knots_x[i - 1] != @knots_x[i]
          @knots_x[i] = @knots_x[i] + (@knots_x[i - 1] > @knots_x[i] ? 1 : -1)
        end

        if @knots_y[i - 1] != @knots_y[i]
          @knots_y[i] = @knots_y[i] + (@knots_y[i - 1] > @knots_y[i] ? 1 : -1)
        end
      end
    end
    mark_visited(@knots_x[@num - 1], @knots_y[@num - 1])
  end

  def mark_visited(x, y)
    @visited["#{x},#{y}"] = true
  end

  def print_visited(full = false)
    return unless @debug
    puts ""
    (@grid_min_y..@grid_max_y).each do |y|
      puts ((@grid_min_x..@grid_max_x).map do |x|
             if !full
               knot = @visited["#{x},#{y}"] ? "#" : "." if knot.nil?
               @num.times do |i|
                 if @knots_x[i] == x && @knots_y[i] == y
                   knot = i.to_s
                   break
                 end
               end
               knot
             end
           end.join(""))
    end
  end

  def visited
    @visited.keys.count
  end

  def self.run(arr, num, debug = false)
    grid = Grid.new(num, debug)
    arr.each do |line|
      direction, distance = line.split(" ")
      distance = distance.to_i
      grid.action(direction, distance)
    end
    puts grid.visited
  end
end

Grid.run(arr, 2, false)
Grid.run(arr, 10, false)
