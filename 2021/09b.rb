require '../util.rb'

data = []
File.read('./09.txt').split("\n").each do |line|
  data << line.split("").map(&:to_i)
end

groups = {}

low_points = []
(0...data.size).each do |i|
  row = data[i]
  (0...row.size).each do |j|
    value = row[j]
    low = [[i, j+1], [i, j-1], [i+1, j], [i-1, j]].all? do |(x, y)|
      x < 0 || y < 0 || data[x] == nil || data[x][y] == nil || data[x][y] > value
    end
    low_points << [i, j] if low
  end
end
# pp low_points

sizes = []
groups = []
low_points.each do |(x, y)|
  queue = [[x, y]]
  included = {to_point(x, y) => true}
  
  while !queue.empty?
    # pp queue
    i, j = queue.shift
    [[i, j+1], [i, j-1], [i+1, j], [i-1, j]].each do |i2, j2|
      next if i2 < 0 || j2 < 0 || !data[i2] || !data[i2][j2] || data[i2][j2] == 9
      if data[i2][j2] > data[i][j] && !included[to_point(i2, j2)]
        included[to_point(i2, j2)] = true
        queue << [i2, j2]
      end
    end
  end
  # puts included.size
  sizes << included.size
  groups << included.keys.map { |x| from_point(x) }
end

# p sizes
sizes = sizes.sort.reverse
p sizes[0] * sizes[1] * sizes[2]
puts "Finished in #{Time.now - @start_time} seconds."

colors = ["\e[31m", "\e[32m", "\e[33m", "\e[34m", "\e[35m", "\e[36m"]
groups.each_with_index do |group, index|
  group.each do |(i, j)|
    data[i][j] = "#{colors[index % colors.size]}#{data[i][j]}"
  end
end

data.each do |line|
  line.each_with_index { |x, i| line[i] = "\e[30m9" if x == 9 }
  line[0] = "\e[1m" + line[0]
end

puts data.map(&:join)
puts "\e[0m"
