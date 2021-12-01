require '../util.rb'

result = 0
prev = nil
File.read('./01.txt').split("\n").each do |line|
  cur = line.to_i
  result += 1 if prev && cur > prev
  prev = cur
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
