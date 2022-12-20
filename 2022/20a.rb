require '../util.rb'

numbers = []
File.read('./20.txt').split("\n").each_with_index do |line, i|
  numbers << line.to_i
end

Node = Struct.new(:value, :prev, :next) do
  def print
    list = [value]
    node = self.next
    while node != self
      list << node.value
      node = node.next
    end
    p list
  end
end

prev = Node.new(numbers.first, nil, nil)
nodes = [prev]
numbers.each_with_index do |n, i|
  next if i == 0
  node = Node.new(n, prev, nil)
  nodes << node
  prev.next = node
  prev = node
end

nodes.last.next = nodes.first
nodes.first.prev = nodes.last

nodes.each do |node|
  # nodes.find { |n| n.value == 1 }.print
  shift = (node.value) % (nodes.size - 1)
  p1, n1 = node.prev, node.next
  node2 = node
  shift.times do
    node2 = node2.next
  end
  next if node2 == node
  n2 = node2.next
  p1.next = n1
  n1.prev = p1
  node.next = n2
  node.prev = node2
  node2.next = node
  n2.prev = node
end

node = nodes.find { |n| n.value == 0 }
1000.times { node = node.next }
a = node.value
1000.times { node = node.next }
b = node.value
1000.times { node = node.next }
c = node.value

puts a + b + c

puts "Finished in #{Time.now - @start_time} seconds."
