require '../util.rb'

result = 0
File.read('./06.txt').split("\n\n").each do |group|
  hash = {}
  group.split("\n").join('').split('').each { |c| hash[c] = true }
  result += hash.size
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
