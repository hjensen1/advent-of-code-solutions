require '../util.rb'

def score(a, x)
  total = 0
  if a == x
    total += 3
  elsif a == 'A' && x == 'B' || a == 'B' && x == 'C' || a == 'C' && x == 'A'
    total += 6
  end
  if x == 'A'
    total += 1
  elsif x == 'B'
    total += 2
  elsif x == 'C'
    total += 3
  end
end

map = { 'X' => 'A', 'Y' => 'B', 'Z' => 'C' }
result = 0
File.read('./02a.txt').split("\n").each do |line|
  a, x = line.split
  x = map[x]
  result += score(a, x)
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."

# Code golf

p STDIN.read.split("\n").sum{|l|x=l[2].ord-87;(x-l.ord+2)%3*3+x}
