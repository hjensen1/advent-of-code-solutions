require '../util.rb'

grid = []
scores = []
File.read('./08.txt').split("\n").each do |line|
  grid << line.split("").map(&:to_i)
  scores << [0] * line.size
end

def get_lines(grid, y, x)
  [
    [y].product((0...x).to_a.reverse),
    [y].product(((x+1)...grid.first.size).to_a),
    (0...y).to_a.reverse.product([x]),
    ((y+1)...grid.size).to_a.product([x]),
  ]
end

def get_score(grid, y, x)
  score = 1
  get_lines(grid, y, x).each do |line|
    sub = 0
    height = grid[y][x]
    line.each do |vy, vx|
      sub += 1
      break if grid[vy][vx] >= height
    end
    score *= sub
  end
  score
end

max = 0
(0...grid.size).each do |y|
  (0...grid.first.size).each do |x|
    score = get_score(grid, y, x)
    scores[y][x] = score
    if score > max
      max = score
    end
  end
end
pp scores
puts max
puts "Finished in #{Time.now - @start_time} seconds."
