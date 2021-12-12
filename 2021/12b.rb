require '../util.rb'

@nodes = Set.new
@edges = Hash.new { |h, k| h[k] = [] }
File.read('./12.txt').split("\n").each do |line|
  a, b = line.split("-")
  @nodes.add(a)
  @nodes.add(b)
  @edges[a] << b unless b == "start"
  @edges[b] << a unless a == "start"
end

@count = 0
@doubled = nil

def recurse(stack = ["start"], set = Set.new(["start"]))
  last = stack.last
  # pp stack
  if last == "end"
    @count += 1
    return
  end
  @edges[last].each do |node|
    next if node.downcase == node && set.include?(node) && @doubled
    stack << node
    @doubled = node if node.downcase == node && set.include?(node)
    set.add(node)
    recurse(stack, set)
    stack.pop
    if @doubled && node == @doubled
      @doubled = nil
    else
      set.delete(node)
    end
  end
end

recurse

puts @count
puts "Finished in #{Time.now - @start_time} seconds."
