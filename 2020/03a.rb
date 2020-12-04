require '../util.rb'

position = 0
result = 0
File.read('./03.txt').split("\n").each do |line|
  puts line.slice(0, position + 1)
  result += 1 if line[position] == '#'
  position = (position + 3) % (line.length)
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
