require '../util.rb'

@nodes = Set.new
@edges = Hash.new { |h, k| h[k] = [] }
File.read('./12.txt').split("\n").each do |line|
  a, b = line.split("-")
  @nodes.add(a)
  @nodes.add(b)
  @edges[a] << b
  @edges[b] << a
end

@count = 0

def recurse(stack = ["start"], set = Set.new(["start"]))
  last = stack.last
  pp stack
  if last == "end"
    @count += 1
    return
  end
  @edges[last].each do |node|
    next if node.downcase == node && set.include?(node)
    stack << node
    set.add(node)
    recurse(stack, set)
    stack.pop
    set.delete(node)
  end
end

recurse

puts @count
puts "Finished in #{Time.now - @start_time} seconds."
