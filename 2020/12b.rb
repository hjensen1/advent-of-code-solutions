require '../util.rb'

x = y = 0
dx = 10
dy = 1

File.read('./12.txt').split("\n").each do |line|
  s = line[0]
  d = line[1, 10].to_i
  theta = 0
  if s == 'N'
    dy += d
  elsif s == 'E'
    dx += d
  elsif s == 'S'
    dy -= d
  elsif s == 'W'
    dx -= d
  elsif s == 'L'
    theta = d
  elsif s == 'R'
    theta = -d % 360
  elsif s == 'F'
    y += dy * d
    x += dx * d
  end
  if theta == 90
    dx, dy = [-dy, dx]
  elsif theta == 180
    dx, dy = [-dx, -dy]
  elsif theta == 270
    dx, dy = [dy, -dx]
  end
  # p [x, y, dx, dy, theta]
end

puts x.abs + y.abs
puts "Finished in #{Time.now - @start_time} seconds."
