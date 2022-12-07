require '../util.rb'

F = Struct.new(:path, :name, :size) do
  def compute_size
    size
  end
end

D = Struct.new(:path, :name, :size, :parent, :children) do
  def compute_size
    self.size ||= children.sum(&:compute_size)
  end

  def flatten
    ds = children.select { |x| x.is_a?(D) }
    ds.map(&:compute_size).concat(ds.map(&:flatten))
  end
end

path = "/"
dir = D.new('/', '/', nil, nil, [])
root = dir
File.read('./07.txt').split("\n").each do |line|
  if line.start_with?('dir ')
    dir.children << D.new(File.join(path, line[4, 100]), line[4, 100], nil, dir, [])
  elsif match = line.match(/^\d+ (.+)$/)
    dir.children << F.new(File.join(path, match[1]), match[1], line.to_i)
  elsif line == '$ ls'
    next
  elsif line == '$ cd ..'
    path = File.dirname(path)
    dir = dir.parent
  else
    path = File.join(path, line[5, 100])
    dir = dir.children.find { |d| d.path == path }
  end
end

root.compute_size
diff = root.compute_size - 40000000
p root.flatten.flatten.sort.select { |x| x >= diff }.first
puts "Finished in #{Time.now - @start_time} seconds."
