require '../util.rb'

tiles = Hash.new(false)
File.read('./24.txt').split("\n").each do |line|
  direction = ''
  x, y = 0, 0
  line.each_char do |char|
    direction << char
    if char == 'w' || char == 'e'
      if direction == 'w'
        x -= 2
      elsif direction == 'e'
        x += 2
      elsif direction == 'nw'
        x -= 1
        y += 1
      elsif direction == 'ne'
        x += 1
        y += 1
      elsif direction == 'sw'
        x -= 1
        y -= 1
      elsif direction == 'se'
        x += 1
        y -= 1
      end
      direction = ''
    end
  end
  tiles[[x, y]] = !tiles[[x, y]]
end

puts tiles.values.select { |x| x }.size
puts "Finished in #{Time.now - @start_time} seconds."
