require '../util.rb'

points = []
folds = nil
File.read('./13.txt').split("\n").each do |line|
  if folds
    folds << line
  elsif line.empty?
    folds = []
  else
    points << line
  end
end

def do_fold(point, xfold, yfold)
  x, y = from_point(point)
  if xfold
    if x > xfold
      x = x - xfold
      x = xfold - x
    end
  end
  if yfold
    if y > yfold
      y = y - yfold
      y = yfold - y
    end
  end
  to_point(x, y)
end

folds.each do |fold|
  parts = fold.split("=")
  value = parts.last.to_i
  points.each_with_index do |point, index|
    points[index] = do_fold(point, parts[0].end_with?("x") ? value : nil, parts[0].end_with?("y") ? value : nil)
  end
  points = points.uniq
end

xmax = points.map { |x| from_point(x)[0] }.max
ymax = points.map { |x| from_point(x)[1] }.max

set = Set.new(points)

(0..ymax).each do |y|
  (0..xmax).each do |x|
    print set.include?(to_point(x, y)) ? "#" : "."
  end
  puts
end

puts "Finished in #{Time.now - @start_time} seconds."
