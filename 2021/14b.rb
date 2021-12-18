require '../util.rb'

string3 = nil
map = {}
File.read('./14.txt').split("\n").each_with_index do |line, i|
  if i == 0
    string3 = line
  elsif i > 1
    parts = line.split(" -> ")
    map[parts[0]] = parts[1]
  end
end

pairs = Hash.new { |h, k| h[k] = Hash.new(0) }
singles = Hash.new { |h, k| h[k] = Hash.new(0) }
map.each_pair do |k, v|
  string = k
  10.times do
    string2 = ""
    (0...(string.size)).each do |i|
      s = string[i, 2]
      string2 << string[i]
      string2 << map[s] if map[s]
    end
    string = string2
    # p string.size
  end
  (0...(string.size - 1)).each do |i|
    s = string[i, 2]
    pairs[k][s] += 1
    singles[k][string[i]] += 1
  end
end
pp pairs

list = string3.split("").each_cons(2).to_a.map { |x| x.join("") }
counts = list.tally
pp counts

4.times do | i|
  new_counts = Hash.new(0)
  counts.each_pair do |k, v|
    pairs[k].each_pair do |k2, v2|
      new_counts[k2] += v * v2
    end
  end
  counts = new_counts
  p i
  pp counts
end

totals = Hash.new(0)
counts.each_pair do |k, v|
  k.split("").each { |c| totals[c] += v }
end

totals[string3[0]] -= 1
totals[string3[string3.size - 1]] += 1
totals.each { |(k, v)| totals[k] = v / 2 }

pp totals


totals = totals.to_a.sort_by { |x| x[1] }
puts totals.last[1] - totals.first[1]
puts "Finished in #{Time.now - @start_time} seconds."
