require '../util.rb'

result = 0
File.read('./04.txt').split("\n").each do |line|
  a, b, c, d = line.split(/[-,]/).map(&:to_i)
  r1 = (a..b).to_a
  r2 = (c..d).to_a
  result += 1 if (r2 - r1).empty? || (r1 - r2).empty?
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
