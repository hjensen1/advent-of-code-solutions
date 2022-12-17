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

Search = Struct.new(:graph, :flows, :visited, :permutations, :best) do
  def find_permutations(node = "AA", minutes = 26, score = 0)
    permutations << { nodes: visited.dup, score: score } unless node == "AA"

    graph[node].each_pair do |node2, distance|
      next if visited.include?(node2)
      t = minutes - distance - 1
      flow = flows[node2]
      visited << node2

      if minutes > 0
        find_permutations(node2, t, score + t * flow)
      else
        # Stop searching
      end

      visited.pop
    end

    permutations
  end
end

search = Search.new(graph, flows, [], [], 0)
permutations = search.find_permutations
puts permutations.size
pp permutations.last

combinations = {}
permutations.each do |p|
  nodes = p[:nodes]
  score = p[:score]
  c = nodes.sort
  combinations[c] = score if combinations[c].nil? || combinations[c] < score
end

puts combinations.size

best = 0
combinations.to_a.combination(2) do |(ac, ascore), (bc, bscore)|
  next if ac.any? { |x| bc.include?(x) }
  score = ascore + bscore
  best = score if score > best
end
puts best
puts "Finished in #{Time.now - @start_time} seconds."
