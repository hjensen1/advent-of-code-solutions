require '../util.rb'

cubes = {}
File.read('./18.txt').split("\n").each do |line|
  x, y, z = line.split(',').map(&:to_i)
  cubes[[x, y, z]] = 6
end

cubes.each_pair do |(x, y, z), faces|
  count = [[x-1, y, z], [x+1, y, z], [x, y-1, z], [x, y+1, z], [x, y, z-1], [x, y, z+1]].count do |point|
    cubes[point]
  end
  cubes[[x, y, z]] = faces - count
end

puts cubes.values.sum
puts "Finished in #{Time.now - @start_time} seconds."
