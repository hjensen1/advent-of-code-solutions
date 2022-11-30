require '../util.rb'

TRANSFORMS = [0, 1, 2].permutation(3).to_a.product(
  [[1,1,1], [1,1,-1], [1,-1,1], [1,-1,-1], [-1,1,1], [-1,1,-1], [-1,-1,1], [-1,-1,-1]]
)

def do_transform(point, transform)
  permutation, sign = transform
  (0..2).map { |i| point[permutation[i]] * sign[i] }
end

def transform_list(points, transform)
  points.each_with_index do |point, i|
    points[i] = do_transform(point, transform)
  end
end

def do_diff(a, b)
  [a[0] - b[0], a[1] - b[1], a[2] - b[2]]
end



Scanner = Struct.new(:id, :points, :diffs_sorted, :shared, :location) do
  def initialize(id, points = [], diffs_sorted = {}, shared = Hash.new { |h, k| h[k] = Set.new }, location = [0, 0, 0])
    super
  end

  def compute_diffs
    points.combination(2).each do |(a, b)|
      diff = do_diff(a, b)
      diffs_sorted[diff.map(&:abs).sort] = [a, b]
    end
  end

  def find_shared(other)
    diffs_sorted.each_pair do |diff1, (a, b)|
      if other.diffs_sorted[diff1]
        shared[other.id].add(a)
        shared[other.id].add(b)
      end
    end
  end

  def find_transform(other)
    return if shared[other.id].size < 12
    a, b, c = shared[other.id].to_a.first(3)
    diff_sorted = do_diff(a, b).map(&:abs).sort
    other_a, other_b = other.diffs_sorted[diff_sorted]
    other_diff = do_diff(other_a, other_b)
    a2, b2 = a, b
    transform = TRANSFORMS.find do |t|
      a2, b2 = do_transform(a, t), do_transform(b, t)
      if do_diff(a2, b2) == other_diff
        t
      end
    end

    diff_sorted = do_diff(b, c).map(&:abs).sort
    b3, c3 = other.diffs_sorted[diff_sorted]
    c3, b3 = b3, c3 if b3 != other_b && b3 != other_a
    if do_diff(do_transform(b, transform), do_transform(c, transform)) != do_diff(b3, c3)
      transform = [transform[0], transform[1].map { |x| -x }]
    end
    transform
  end

  def reorient(transform)
    transform_list(points, transform)
    diffs_sorted.each_pair do |diff, pair|
      transform_list(pair, transform)
    end
    shared.each_pair do |id, set|
      shared[id] = Set.new(transform_list(set.to_a, transform))
    end
  end

  def set_location(other)
    a, b = shared[other.id].to_a.first(2)
    diff_sorted = do_diff(a, b).map(&:abs).sort
    other_a, other_b = other.diffs_sorted[diff_sorted]
    other_a, other_b = other_b, other_a if ((a[0] > b[0]) != (other_a[0] > other_b[0]))
    (0..2).each do |i|
      location[i] = other.location[i] + other_a[i] - a[i]
    end
  end

  def recursive_reorient(other = nil)
    if other
      transform = find_transform(other)
      reorient(transform)
      set_location(other)
    end
    shared.each_pair do |id, set|
      if id != 0 && SCANNERS[id].location == [0, 0, 0] && set.size >= 12
        SCANNERS[id].recursive_reorient(self)
      end
    end
  end
end



SCANNERS = scanners = []
File.read('./19.txt').split("\n").each do |line|
  if line.start_with?("---")
    scanners << Scanner.new(scanners.size)
  elsif line.empty?
  else
    scanners.last.points << line.split(",").map(&:to_i)
  end
end


scanners.each(&:compute_diffs)

scanners.each_with_index do |s1, i|
  scanners.each_with_index do |s2, j|
    next if j == i
    s1.find_shared(s2)
    # break
  end
end

scanners[0].recursive_reorient
p scanners.map(&:location)

max = 0
scanners.combination(2).each do |(a, b)|
  d = do_diff(a.location, b.location).map(&:abs).sum
  max = d if d > max
end

puts max
puts "Finished in #{Time.now - @start_time} seconds."
