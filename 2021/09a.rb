require '../util.rb'

data = []
File.read('./09.txt').split("\n").each do |line|
  data << line.split("").map(&:to_i)
end

sum = 0
(0...data.size).each do |i|
  row = data[i]
  (0...row.size).each do |j|
    value = row[j]
    low = [[i, j+1], [i, j-1], [i+1, j], [i-1, j]].all? do |(x, y)|
      x < 0 || y < 0 || data[x] == nil || data[x][y] == nil || data[x][y] > value
    end
    sum += value + 1 if low
  end
end

puts sum
puts "Finished in #{Time.now - @start_time} seconds."
