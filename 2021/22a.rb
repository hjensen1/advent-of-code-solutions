require '../util.rb'

steps = []
File.read('./22.txt').split("\n").each do |line|
  parts = line.split(/[^0-9\-]+/).reject(&:empty?).map(&:to_i)
  parts << (line.split(" ").first == "on" ? true : false)
  steps << parts
end

cubes = Hash.new(false)

steps.each_with_index do |(x1, x2, y1, y2, z1, z2, state), index|
  next if [x1, x2, y1, y2, z1, z2].any? { |a| a > 50 || a < -50 }
  (x1..x2).each do |x|
    (y1..y2).each do |y|
      (z1..z2).each do |z|
        cubes[[x,y,z]] = state
      end
    end
  end
end

puts cubes.values.count { |x| x }
puts "Finished in #{Time.now - @start_time} seconds."
