#!/usr/bin/ruby
arr = File.readlines('data.txt')
arr = arr.map(&:strip)

# arr.each_with_index do |l, i|
#   if l[i * 3 % l.length] == '#'
#     l[i * 3 % l.length] = 'X'
#   else
#     l[i * 3 % l.length] = '0'
#   end
#   puts l
# end

def trees(w, h, arr)
  arr.each_with_index.select {|l, i| i % h == 0 }.count do |l, i|
    l[i * w % l.length] == '#'
  end
end

puts 'star 1'
puts trees(3, 1, arr)
puts 'star 2'
puts [[1, 1],[3, 1], [5, 1], [7, 1], [1, 2]].map { |w, h|
  trees(w, h, arr)
}.inject(&:*)
