require '../util.rb'

string = nil
map = {}
File.read('./14.txt').split("\n").each_with_index do |line, i|
  if i == 0
    string = line
  elsif i > 1
    parts = line.split(" -> ")
    map[parts[0]] = parts[1]
  end
end


10.times do
  string2 = ""
  (0...(string.size)).each do |i|
    s = string[i, 2]
    string2 << string[i]
    string2 << map[s] if map[s]
  end
  string = string2
  # puts string
end

chars = string.split("").tally.to_a.sort_by { |x| x[1] }
puts chars.last[1] - chars.first[1]
puts "Finished in #{Time.now - @start_time} seconds."
