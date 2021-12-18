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

points.each_with_index do |point, index|
  points[index] = do_fold(point, 655, nil)
end

puts points.uniq.size
puts "Finished in #{Time.now - @start_time} seconds."
