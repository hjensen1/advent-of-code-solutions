require '../util.rb'

ps = File.read('./21.txt').split("\n").map { |x| x.split(" ").last.to_i }
frequencies = Hash.new(0)
(1..3).each { |x| (1..3).each { |y| (1..3).each { |z| frequencies[x + y + z] += 1 } } }

score_tally = Hash.new(0)
score_tally[[ps[0], ps[1], 0, 0, 0]] = 1
queue = Hash.new(0)
queue[[ps[0], ps[1], 0, 0, 0]] = 1

while !queue.empty?
  state, c = queue.first
  queue.delete(state)
  player = state[4]
  frequencies.each_pair do |value, count|
    new_state = state.dup
    new_state[player] = (new_state[player] - 1 + value) % 10 + 1
    new_state[player + 2] += new_state[player]
    new_state[4] = player == 0 ? 1 : 0
    total = c * count
    score_tally[new_state[0, 4]] += total
    queue[new_state] += total unless new_state[2] >= 21 || new_state[3] >= 21
  end
end

sums = [0, 0]
score_tally.each_pair do |state, count|
  if state[2] >= 21
    sums[0] += count
  elsif state[3] >= 21
    sums[1] += count
  end
end
puts sums
puts "Finished in #{Time.now - @start_time} seconds."
