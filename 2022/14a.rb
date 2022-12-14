require '../util.rb'

map = {}
File.read('./14.txt').split("\n").each do |line|
  parts = line.split(" -> ").map { |x| x.split(',').map(&:to_i) }
  parts.each_cons(2) do |(x1, y1), (x2, y2)|
    if x1 == x2
      (([y1, y2].min)..([y1, y2].max)).each do |y|
        map[[x1, y]] = "#"
      end
    else
      (([x1, x2].min)..([x1, x2].max)).each do |x|
        map[[x, y1]] = "#"
      end
    end
  end
end
maxy = map.keys.map(&:last).max

loop do
  x = 500
  y = 0
  done = false
  loop do
    coords = [[x, y+1], [x-1, y+1], [x+1, y+1]].find { |x2, y2| map[[x2, y2]].nil? }
    break unless coords
    x, y = coords
    if y > maxy
      done = true
      break
    end
  end
  break if done
  map[[x, y]] = "o"
end

puts map.values.count { |x| x == 'o'}
puts "Finished in #{Time.now - @start_time} seconds."
