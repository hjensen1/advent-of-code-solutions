require '../util.rb'

result = 0
grid = []
best = []
File.read('./12.txt').split("\n").each do |line|
  grid << line.split("").map { |c| c.ord - 97 }
  best << [1_000_000] * line.size
end
start = nil
finish = nil
(0...grid.size).each do |y|
  (0...grid.first.size).each do |x|
    if grid[y][x] == -14
      grid[y][x] = 0
      best[y][x] = 0
      start = [y, x]
    elsif grid[y][x] == -28
      grid[y][x] = 25
      finish = [y, x]
    end
  end
end

queue = [start]
while !queue.empty?
  y, x = queue.shift
  [[-1, 0], [0, -1], [1, 0], [0, 1]].each do |dy, dx|
    p [x, y, dx, dy]
    xx = x + dx
    yy = y + dy
    next if yy < 0 || yy >= grid.size
    next if xx < 0 || xx >= grid.first.size
    h = grid[y][x]
    hh = grid[yy][xx]
    if hh <= h + 1 && best[yy][xx] > best[y][x] + 1
      best[yy][xx] = best[y][x] + 1
      queue << [yy, xx]
    end
  end
end

puts best[finish[0]][finish[1]]
puts "Finished in #{Time.now - @start_time} seconds."
