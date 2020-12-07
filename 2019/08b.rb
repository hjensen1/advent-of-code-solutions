require '../util.rb'

width = 25
height = 6

layers = []

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

result = ['                         ', '                         ', '                         ',
  '                         ', '                         ', '                         ']
layers.each do |layer|
  layer.each_with_index do |row, y|
    (0...row.size).each do |x|
      char = row[x]
      if char == '0'
        result[y][x] = '.' if result[y][x] == ' '
      elsif char =='1'
        result[y][x] = '#' if result[y][x] == ' '
      end
    end
  end
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
