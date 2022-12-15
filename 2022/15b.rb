require '../util.rb'

Box = Struct.new(:x, :y, :r) do
  def include?(x, y)
    (x - self.x).abs + (y - self.y).abs <= r
  end
end

boxes = []
gtplus = []
gtminus = []
ltplus = []
ltminus = []
File.read('./15.txt').split("\n").each do |line|
  _, _, _, sx, _, sy, _, _, _, _, _, bx, _, by = line.split(/[ =]/).map(&:to_i)
  # p [sx, sy, bx, by]
  r = (sx - bx).abs + (sy - by).abs
  boxes << Box.new(sx, sy, r)
  lx = sx - r
  gtplus << lx - sy
  ltminus << lx + sy
  rx = sx + r
  gtminus << rx + sy
  ltplus << rx - sy
end

gtplus.sort!
gtminus.sort!
ltplus.sort!
ltminus.sort!

plus = gtplus + ltplus
minus = gtminus + ltminus

solutions = []
plus.each do |plus|
  minus.each do |minus|
    x = (plus + minus).to_f / 2
    y = (x - plus)
    solutions.concat([
      [x.floor - 1, y.floor],
      [x.floor - 1, y.ceil],
      [x.ceil + 1, y.floor],
      [x.ceil + 1, y.ceil],
      [x.floor, y.floor - 1],
      [x.floor, y.ceil + 1],
      [x.ceil, y.floor - 1],
      [x.ceil, y.ceil + 1],
    ])
  end
end

solutions.uniq!
solutions.reject! { |s| boxes.any? { |b| b.include?(*s) } }
solutions.select! { |x, y| x >= 0 && x <= 4000000 && y >= 0 && y <= 4000000 }

x, y = solutions.last
p x * 4000000 + y
puts "Finished in #{Time.now - @start_time} seconds."
