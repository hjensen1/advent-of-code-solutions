require '../util.rb'

result = 0
File.read('./05.txt').split("\n").each do |line|
  row = line[0, 7].gsub('B', '1').gsub('F', '0').to_i(2)
  column = line[7, 3].gsub('R', '1').gsub('L', '0').to_i(2)
  x = row * 8 + column
  result = x if x > result
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
