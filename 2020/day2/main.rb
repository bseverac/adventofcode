arr = File.readlines('data.txt')
arr = arr.map(&:strip)

def match(string)
  m = string.match(/^(?<min>\d{1,})-(?<max>\d{1,}) (?<chr>.): (?<psw>.*)$/)
  yield(m[:min].to_i, m[:max].to_i, m[:chr], m[:psw])
end

def match_first?(string)
  match(string) { |min, max, chr, psw| (min..max).include? psw.count(chr) }
end

def match_second?(string)
  match(string) { |min, max, chr, psw| (psw[min - 1] == chr) ^ (psw[max - 1] == chr) }
end

puts arr.select{ |l| match_first?(l) }.count
puts arr.select{ |l| match_second?(l) }.count
