require '../util.rb'

F = Struct.new(:path, :name, :size) do
  def compute_size
    size
  end

  def answer
    0
  end
end

D = Struct.new(:path, :name, :size, :parent, :children) do
  def compute_size
    self.size ||= children.sum(&:compute_size)
  end

  def answer
    result = children.sum(&:answer)
    result += compute_size if compute_size <= 100000
    result
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
puts root.answer
puts "Finished in #{Time.now - @start_time} seconds."

# Code golf

d=Hash.new(0)
p=[]
STDIN.each_line{|l|l[/\d/]?(0..p.size).each{|i|d[p[0,i]]+=l.to_i}:l['..']?p.pop: l['d ']?p<<l[5,99]:0}
v=d.values
p v.sum{|x|x<=1E5?x:0},v.sort.find{|x|x>d[[]]-4E7}
