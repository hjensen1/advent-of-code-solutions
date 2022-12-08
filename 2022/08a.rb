require '../util.rb'

grid = []
flags = []
File.read('./08.txt').split("\n").each do |line|
  grid << line.split("").map(&:to_i)
  flags << [false] * line.size
end

def process_row(grid, flags, row)
  max = -1
  row.each do |y, x|
    if grid[y][x] > max
      max = grid[y][x]
      flags[y][x] = true
    end
  end
end

(0...grid.size).each do |y|
  process_row(grid, flags, (0...grid.first.size).map { |x| [y, x] })
end
(0...grid.size).each do |y|
  process_row(grid, flags, (0...grid.first.size).to_a.reverse.map { |x| [y, x] })
end
(0...grid.first.size).each do |x|
  process_row(grid, flags, (0...grid.size).map { |y| [y, x] })
end
(0...grid.first.size).each do |x|
  row = grid.map { |r| r[x] }
  process_row(grid, flags, (0...grid.size).to_a.reverse.map { |y| [y, x] })
end

pp flags
puts flags.sum { |row| row.sum { |x| x ? 1 : 0 } }
puts "Finished in #{Time.now - @start_time} seconds."
