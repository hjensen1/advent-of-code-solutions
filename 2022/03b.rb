require '../util.rb'

result = 0
group = []
File.read('./03.txt').split("\n").each do |line|
  group << line.split("").uniq
  if group.size == 3
    char = group[0] & group[1] & group[2]
    x = char[0].ord
    result += x > 96 ? x - 96 : x - 65 + 27
    group = []
  end
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
