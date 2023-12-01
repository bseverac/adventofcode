#!/usr/bin/env ruby
str = File.read("data.txt")

arr = str.split("\n")

class Directory
  attr_accessor :name, :children, :parent

  def initialize(name, parent)
    @name = name
    @parent = parent
    @children = []
  end

  def get_child(name)
    @children.find { |child| child.name == name } || create_child(name)
  end

  def create_child(name)
    child = Directory.new(name, self)
    @children << child
    child
  end

  def add_file(name, size)
    @children << File.new(name, size, self)
  end

  def size
    @size ||= calc_size
  end

  def calc_size
    @children.map(&:size).reduce(0, :+)
  end

  def directories
    @directories ||= @children.select { |child| child.is_a?(Directory) }
  end
end

class File
  attr_accessor :name, :size, :parent

  def initialize(name, size, parent)
    @name = name
    @size = size
    @parent = parent
  end
end

class Tree
  attr_accessor :directories, :current_dir, :root

  def initialize(arr)
    @root = Directory.new("/", nil)
    @current_dir = @root
    parse(arr)
  end

  def parse(arr)
    line = arr.shift
    if line =~ /^\$ cd (.+)/
      go_to_dir($1)
    elsif line =~ /^\$ ls/
      parse_ls(arr)
    end
    parse(arr) unless arr.empty?
  end

  def parse_ls(arr)
    while !(arr[0] =~ /^\$/ || arr.empty?)
      line = arr.shift
      if line =~ /^\$ dir (.+)/
        @current_dir.create_child($1)
      else line =~ /^(\d+) (.+)/
        @current_dir.add_file($2, $1.to_i)       end
    end
  end

  def go_to_dir(name)
    if name == ".."
      @current_dir = @current_dir.parent
    else
      @current_dir = @current_dir.get_child(name)
    end
  end

  def flatten_directories(dir = @root)
    dir.directories + dir.directories.map { |child| flatten_directories(child) }.flatten
  end
end

tree = Tree.new(arr)

def star1(tree)
  tree.flatten_directories.select { |dir| dir.size < 100000 }.sum(&:size)
end

def star2(tree)
  unused_space = 70000000 - tree.root.size
  space_to_free = 30000000 - unused_space
  tree.flatten_directories.select { |dir| dir.size > space_to_free }.sort_by(&:size).first.size
end

puts "star1: #{star1(tree)}"
puts "star2: #{star2(tree)}"
