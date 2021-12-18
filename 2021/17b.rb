require '../util.rb'

@xmin = 248
@xmax = 285
@ymin = -85
@ymax = -56

# @xmin = 20
# @xmax = 30
# @ymin = -10
# @ymax = -5

def step(x, y, dx, dy, max = 0)
  x += dx
  y += dy
  dx -= 1 if dx > 0
  dy -= 1
  if x >= @xmin && x <= @xmax && y >= @ymin && y <= @ymax
    return [true, max]
  elsif x > @xmax || y < @ymin || (x < @xmin && dx == 0)
    return [false, max]
  else
    return step(x, y, dx, dy, y > max ? y : max)
  end
end

max = 0
count = 0
(0...300).each do |dx|
  (-300...300).each do |dy|
    success, m = step(0, 0, dx, dy, 0)
    max = m if m > max && success
    count += 1 if success
  end
end

puts count
puts "Finished in #{Time.now - @start_time} seconds."
