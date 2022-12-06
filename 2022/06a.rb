require '../util.rb'

result = 0
File.read('./06.txt').split("\n").each do |line|
  i = 0
  loop do
    chars = line[i, 4].split("").uniq
    break if chars.size == 4
    i += 1
  end
  result = i + 4
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
