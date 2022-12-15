require '../util.rb'

Box = Struct.new(:x, :y, :r, :count) do
  def &(other)
    d = (y - other.y).abs + (x - other.x).abs
    return nil if d > r + other.r

  end

  def size
    n = r + 1
    n * (n + 1) * (2 * n + 1) / 6
  end
end

result = 0
boxes = []
ty = 2000000
target = {}
File.read('./15.txt').split("\n").each do |line|
  _, _, _, sx, _, sy, _, _, _, _, _, bx, _, by = line.split(/[ =]/).map(&:to_i)
  # p [sx, sy, bx, by]
  target[bx] = 0 if by == ty
  r = (sx - bx).abs + (sy - by).abs
  boxes << Box.new(sx, sy, r)
  # target[sx] = 0 if sy == ty
  dy = (ty - sy).abs
  dx = r - dy
  next if dx < 0
  ((sx - dx)..sx).each { |i| target[i] ||= 1 }
  (sx..(sx + dx)).each { |i| target[i] ||= 1 }
end

puts target.values.sum
puts "Finished in #{Time.now - @start_time} seconds."
