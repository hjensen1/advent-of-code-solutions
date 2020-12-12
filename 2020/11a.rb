require '../util.rb'

rows = []
File.read('./11.txt').split("\n").each do |line|
  rows << line
end

def count(rows, x, y)
  result = 0
  ([y - 1, 0].max..[y + 1, rows.size].min).each do |i|
    ([x - 1, 0].max..[x + 1, rows.first.size].min).each do |j|
      result += 1 if rows[i]&.[](j) == '#'
    end
  end
  result
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
  puts rows
  rows2 = stuff(rows)
  count = 0
  rows2.each_with_index do |row, i|
    count += 1 if row == rows[i]
  end
  break if count == rows.size
  rows = rows2
end

count = 0
rows.each do |row|
  row.each_char do |char|
    count += 1 if char == '#'
  end
end

puts count
puts "Finished in #{Time.now - @start_time} seconds."
