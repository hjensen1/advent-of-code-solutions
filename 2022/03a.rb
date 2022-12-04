require '../util.rb'

result = 0
File.read('./03.txt').split("\n").each do |line|
  a, b = line[0, line.size / 2], line[line.size / 2, line.size]
  achars = a.split("").uniq
  bchars = b.split("").uniq
  chars = achars & bchars
  char = chars[0]
  x = char.ord
  result += x > 96 ? x - 96 : x - 65 + 27
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
