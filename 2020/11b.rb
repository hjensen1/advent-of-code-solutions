require '../util.rb'

@size = 100

rows = []
File.read('./11.txt').split("\n").each do |line|
  rows << line
end

def count(rows, x, y)
  result = ['.'] * 8
  (1..@size).each do |r|
    [[x-r, y-r], [x-r, y], [x-r, y+r], [x, y-r], [x, y+r], [x+r, y-r], [x+r, y], [x+r, y+r]].each_with_index do |coords, i|
      x1, y1 = coords
      if x1 < 0 || y1 < 0 || y1 > rows.size - 1 || x1 > rows.first.size - 1
        result[i] = 'L' if result[i] == '.'
      elsif result[i] == '.'
        result[i] = 'L' if rows[y1][x1] == 'L'
        result[i] = '#' if rows[y1][x1] == '#'
      end
    end
    break if result.count { |a| a == '.' } == 0
  end
  result.count { |a| a == '#' }
end

def stuff(rows)
  result = rows.map(&:dup)
  rows.each_with_index do |row, y|
    row.size.times do |x|
      char = row[x]
      if char == 'L'
        result[y][x] = '#' if count(rows, x, y) == 0
      elsif char == '#'
        result[y][x] = 'L' if count(rows, x, y) >= 5
      end
    end
  end
  result
end

loop do
  # puts rows
  # puts
  rows2 = stuff(rows)
  matching = 0
  rows2.each_with_index do |row, i|
    matching += 1 if row == rows[i]
  end
  rows = rows2
  count = 0
  rows.each do |row|
    row.each_char do |char|
      count += 1 if char == '#'
    end
  end

  puts count
  if matching == rows.size
    break
  end
end


puts "Finished in #{Time.now - @start_time} seconds."
