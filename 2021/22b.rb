require '../util.rb'

Region = Struct.new(:x1, :x2, :y1, :y2, :z1, :z2, :count) do
  def valid?
    x1 <= x2 && y1 <= y2 && z1 <= z2
  end

  def intersection(other)
    region = Region.new(
      [x1, other.x1].max,
      [x2, other.x2].min,
      [y1, other.y1].max,
      [y2, other.y2].min,
      [z1, other.z1].max,
      [z2, other.z2].min,
    )
    region.valid? ? region : nil
  end

  def volume
    (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)
  end

  def same_region?(other)
    x1 == other.x1 && x2 == other.x2 && y1 == other.y1 && y2 == other.y2 && z1 == other.z1 && z2 == other.z2
  end

  def to_s
    "<#{x1}..#{x2},#{y1}..#{y2},#{z1}..#{z2},c=#{count}>"
  end

  def inspect
    to_s
  end

  def eql?(other)
    equal?(other)
  end
end

steps = []
File.read('./22.txt').split("\n").each do |line|
  parts = line.split(/[^0-9\-]+/).reject(&:empty?).map(&:to_i)
  parts << (line.split(" ").first == "on" ? 1 : 0)
  steps << Region.new(*parts)
end

regions = Set.new
steps.each_with_index do |region, index|
  to_add = []
  to_delete = []
  if region.count == 1
    to_add << region
    # puts region
  end
  regions.each do |other|
    intersection = region.intersection(other)
    next unless intersection
    intersection.count = -other.count
    if other.same_region?(intersection)
      to_delete << other
    else
      to_add << intersection
    end
  end
  to_delete.each { |r| regions.delete(r) }
  to_add.each { |r| regions.add(r) }
  puts regions.size
end

puts regions.to_a.map { |r| r.count * r.volume }.sum
puts "Finished in #{Time.now - @start_time} seconds."
