require '../util.rb'

list = []
File.read('./10.txt').split("\n").each do |line|
  list << line.to_i
end
list.sort!
list << list.last + 3

results = Hash.new(0)
results[0] = 1
list.each do |x|
  results[x] = results[x - 1] + results[x - 2] + results[x - 3]
end

puts results
puts results[list.last]
puts "Finished in #{Time.now - @start_time} seconds."
