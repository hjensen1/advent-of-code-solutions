require '../util.rb'

cubes = {}
File.read('./18.txt').split("\n").each do |line|
  x, y, z = line.split(',').map(&:to_i)
  cubes[[x, y, z]] = 6
end

minx = cubes.keys.map { |a| a[0] }.min - 1
maxx = cubes.keys.map { |a| a[0] }.max + 1
miny = cubes.keys.map { |a| a[1] }.min - 1
maxy = cubes.keys.map { |a| a[1] }.max + 1
minz = cubes.keys.map { |a| a[2] }.min - 1
maxz = cubes.keys.map { |a| a[2] }.max + 1
faces = 0
stack = [[minx, miny, minz]]
searched = Set.new(stack)

while !stack.empty?
  x, y, z = stack.pop
  [[x-1, y, z], [x+1, y, z], [x, y-1, z], [x, y+1, z], [x, y, z-1], [x, y, z+1]].each do |point|
    x2, y2, z2 = point
    if cubes[point]
      faces += 1
    elsif x2 >= minx && y2 >= miny && z2 >= minz && x2 <= maxx && y2 <= maxy && z2 <= maxz
      unless searched.include?(point)
        stack << point
        searched << point
      end
    else
      # Out of bounds
    end
  end
end

puts faces
puts "Finished in #{Time.now - @start_time} seconds."
