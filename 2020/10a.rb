require '../util.rb'

list = []
results = {1 => 0, 2 => 0, 3 => 1}
File.read('./10.txt').split("\n").each do |line|
  list << line.to_i
end

prev = 0
list.sort!
list.each do |x|
  results[x - prev] += 1
  prev = x
end

puts results
puts results[1] * results[3]
puts "Finished in #{Time.now - @start_time} seconds."
