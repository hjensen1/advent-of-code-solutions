require '../util.rb'

result = 0
File.read('./06.txt').split("\n\n").each do |group|
  lists = group.split("\n").map { |x| x.split('').sort }
  result += lists.reduce(lists.pop) { |intersection, list| intersection & list }.size
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
