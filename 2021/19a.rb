require '../util.rb'

Scanner = Struct.new(:id, :points, :diffs, :diffs_sorted, :shared) do
  def initialize(id, points, diffs = {}, diffs_sorted = {}, shared = Hash.new { |h, k| h[k] = Set.new })
    super
  end

  def compute_diffs
    points.combination(2).each do |(a, b)|
      diff = [a[0] - b[0], a[1] - b[1], a[2] - b[2]].map(&:abs)

      diffs[diff] = [a, b]
      diffs_sorted[diff.sort] = [a, b]
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
end

scanners = []
File.read('./19.txt').split("\n").each do |line|
  if line.start_with?("---")
    scanners << Scanner.new(scanners.size, [], {})
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

count = 0
scanners.each do |scanner|
  distinct = Set.new(scanner.points)
  scanner.shared.each_pair do |id, shared|
    next if id >= scanner.id
    shared.each do |point|
      distinct.delete(point)
    end
  end
  count += distinct.size
end

puts count

puts "Finished in #{Time.now - @start_time} seconds."
