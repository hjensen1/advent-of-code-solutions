require '../util.rb'

width = 25
height = 6

layers = []

result = 0
File.read('./08.txt').split("\n").each do |line|
  i = 0
  while i < line.size
    layer = []
    height.times do
      layer << line[i, width]
      i += width
    end
    layers << layer
  end
end

best = [1000000, 0, 0]
layers.each do |layer|
  hash = [0, 0, 0]
  layer.each do |row|
    row.each_char do |char|
      hash[char.to_i] += 1
    end
  end
  best = hash if hash[0] < best[0]
end

puts best[1] * best[2]
puts "Finished in #{Time.now - @start_time} seconds."
