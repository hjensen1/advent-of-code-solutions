require '../util.rb'

data = []
File.read('./15.txt').split("\n").each do |line|
  data << line.split("").map(&:to_i)
end

data2 = []
(0...5).each do |i|
  data.each do |line|
    data2 << []
    (0...5).each do |j|
      line.each do |risk|
        data2.last << (risk + j + i - 1) % 9 + 1
      end
    end
  end
end
data = data2
data[0][0] = 0

# puts data.map { |line| line.join("") }.join("\n")

results = Array.new(data.size) { Array.new(data.first.size) { 1_000_000 } }
results[0][0] = 0
queue = [[0, 0]]
while !queue.empty?
  i, j = queue.shift
  [[i-1, j], [i+1, j], [i, j-1], [i, j+1]].each do |(i2, j2)|
    next if i2 < 0 || j2 < 0 || i2 >= data.size || j2 >= data.first.size
    value = results[i][j] + data[i2][j2]
    if value < results[i2][j2]
      results[i2][j2] = value
      queue << [i2, j2]
    end
  end
end

# pp results

puts results.last.last
puts "Finished in #{Time.now - @start_time} seconds."
