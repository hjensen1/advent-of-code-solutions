require '../util.rb'

lines = []
File.read('./05.txt').split("\n").each do |line|
  lines << line.split(" -> ").map { |s| s.split(",")}.flatten.map(&:to_i)
end

map = Array.new(1000) { [0] * 1000 }

lines.each do |line|
  if line[0] == line[2]
    a, b = line[1], line[3]
    a, b = b, a if a > b
    (a..b).each do |i|
      map[i][line[0]] += 1
    end
  elsif line[1] == line[3]
    a, b = line[0], line[2]
    a, b = b, a if a > b
    (a..b).each do |i|
      map[line[1]][i] += 1
    end
  end
end

p map.map { |line| line.count { |x| x > 1 } }.sum
puts "Finished in #{Time.now - @start_time} seconds."
