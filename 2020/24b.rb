require '../util.rb'

cells = Hash.new(false)
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
  cells[[x, y]] = !cells[[x, y]]
end

100.times do
  counts = Hash.new { |h, k| h[k] = 0 }
  cells.each_pair do |(x, y), value|
    counts[[x, y]]
    [[x-2, y], [x+2, y], [x-1, y-1], [x-1, y+1], [x+1, y-1], [x+1, y+1]].each do |coords|
      counts[coords] += 1 if value
    end
  end

  counts.each_pair do |coords, count|
    if cells[coords]
      cells[coords] = false if count == 0 || count > 2
    else
      cells[coords] = true if count == 2
    end
  end

  puts cells.values.select { |x| x}.size
end

puts "Finished in #{Time.now - @start_time} seconds."
