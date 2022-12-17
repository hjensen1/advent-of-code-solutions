require '../util.rb'

Edge = Struct.new(:dest, :length)

minutes = 30
base_graph = {}
flows = {}
File.read('./16.txt').split("\n").each do |line|
  _, valve, _, _, _, flow, _, _, _, _, *edges = line.split(/\W+/)
  flows[valve] = flow.to_i if flow.to_i != 0 || valve == "AA"
  base_graph[valve] = edges# + [valve + "O"]
  # graph[valve + "O"] = edges
end

graph = {}

flows.keys.each do |start|
  distances = {start => 0}
  pending = []
  pending << start
  while !pending.empty?
    node = pending.shift
    base_graph[node].each do |node2|
      if distances[node2].nil? || distances[node2] > distances[node] + 1
        distances[node2] = distances[node] + 1
        pending << node2
      end
    end
  end
  distances.each_pair do |node, distance|
    next if flows[node].nil? || start == node
    (graph[node] ||= {})[start] = distance
    (graph[start] ||= {})[node] = distance
  end
end

@best = 0
def search(graph, flows, path, node, minutes, score)
  if minutes <= 0 || path.size == graph.size
    if score > @best
      @best = score
      puts score
    end
    return
  end
  graph[node].each_pair do |node2, distance|
    next if path.include?(node2)
    t = minutes - distance - 1
    flow = flows[node2]
    path << node2
    search(graph, flows, path, node2, t, t <= 0 ? score : score + t * flow)
    path.pop
  end
end

search(graph, flows, [], "AA", 30, 0)

puts @best
puts "Finished in #{Time.now - @start_time} seconds."
