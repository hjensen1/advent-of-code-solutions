require '../util.rb'

COLUMNS = [[],[],[],[],[],[],[],[],[],[]]

def move(count, from, to)
  count.times do
    COLUMNS[to].push(COLUMNS[from].pop)
  end
end

mode = 0
File.read('./05.txt').split("\n").each do |line|
  if mode == 0
    if line.empty?
      mode = 1
      next
    end
    a = line.split('')
    (0...9).each do |i|
      c = line[i * 4 + 1]
      if c >= 'A' && c <= 'Z'
        COLUMNS[i + 1].unshift(c)
      end
    end
  else
    a, b, c, d, e, f = line.split(' ').map(&:to_i)
    move(b, d, f)
  end
end

puts COLUMNS.map(&:last).join('')
puts "Finished in #{Time.now - @start_time} seconds."
