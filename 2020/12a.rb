require '../util.rb'

x = y = 0
dx = 1
dy = 0
theta = 0

File.read('./12.txt').split("\n").each do |line|
  s = line[0]
  d = line[1, 10].to_i
  if s == 'N'
    y += d
  elsif s == 'E'
    x += d
  elsif s == 'S'
    y -= d
  elsif s == 'W'
    x -= d
  elsif s == 'L'
    theta = (theta + d) % 360
  elsif s == 'R'
    theta = (theta - d) % 360
  elsif s == 'F'
    y += dy * d
    x += dx * d
  end
  if theta == 0
    dx = 1
    dy = 0
  elsif theta == 90
    dx = 0
    dy = 1
  elsif theta == 180
    dx = -1
    dy = 0
  else
    dx = 0
    dy = -1
  end
  # p [x, y, dx, dy]
end

puts x.abs + y.abs
puts "Finished in #{Time.now - @start_time} seconds."
