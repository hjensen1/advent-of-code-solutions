require '../util.rb'

result = 0
p1 = p2 = p3 = nil
sum = 0
File.read('./01.txt').split("\n").each do |line|
  cur = line.to_i
  if p1 && p2 && p3
    result += 1 if p1 + p2 + cur > p1 + p2 + p3
  end
  p3 = p2
  p2 = p1
  p1 = cur
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
