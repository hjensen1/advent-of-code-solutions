require '../util.rb'

Cell = Struct.new(:id, :value)
Move = Struct.new(:start, :end, :between, :length)

cells = {}
("a".."w").each do |id|
  cells[id] = Cell.new(id, ".")
end

moves = [
  Move.new("b", "1", "", 1),
  Move.new("b", "2", "c", 3),
  Move.new("b", "3", "cd", 5),
  Move.new("b", "4", "cde", 7),
  Move.new("h", "1", "", 1),
  Move.new("h", "2", "c", 3),
  Move.new("h", "3", "cd", 5),
  Move.new("h", "4", "cde", 7),
  Move.new("f", "4", "", 1),
  Move.new("f", "3", "e", 3),
  Move.new("f", "2", "ed", 5),
  Move.new("f", "1", "edc", 7),
  Move.new("t", "4", "", 1),
  Move.new("t", "3", "e", 3),
  Move.new("t", "2", "ed", 5),
  Move.new("t", "1", "edc", 7),
  Move.new("l", "2", "", 1),
  Move.new("l", "1", "c", 3),
  Move.new("l", "3", "d", 3),
  Move.new("l", "4", "de", 5),
  Move.new("p", "3", "", 1),
  Move.new("p", "2", "d", 3),
  Move.new("p", "4", "e", 3),
  Move.new("p", "1", "dc", 5),
]
additional = [
  ["a", "b", "b", 1],
  ["g", "f", "f", 1],
  ["i", "h", "h", 1],
  ["j", "h", "hi", 2],
  ["k", "h", "hij", 3],
  ["m", "l", "l", 1],
  ["n", "l", "lm", 2],
  ["o", "l", "lmn", 3],
  ["q", "p", "p", 1],
  ["r", "p", "pq", 2],
  ["s", "p", "pqr", 3],
  ["u", "t", "t", 1],
  ["v", "t", "tu", 2],
  ["w", "t", "tuv", 3],
]
moves2 = []
additional.each do |(start, near, between, plus)|
  moves.each do |move|
    if move.start == near
      moves2 << Move.new(start, move.end, between + move.between, move.length + plus)
    end
  end
end
moves += moves2
moves += [
  Move.new("c", "1", "", 1),
  Move.new("c", "2", "", 1),
  Move.new("c", "3", "d", 3),
  Move.new("c", "4", "de", 5),
  Move.new("e", "4", "", 1),
  Move.new("e", "3", "", 1),
  Move.new("e", "2", "d", 3),
  Move.new("e", "1", "dc", 5),
  Move.new("d", "1", "c", 3),
  Move.new("d", "2", "", 1),
  Move.new("d", "3", "", 1),
  Move.new("d", "4", "e", 3),
]
puts moves.size

groups = ["abcdefg", "hijk", "lmno", "pqrs", "tuvw"]
groups2 = {}
groups.each do |group|
  group.each_char do |c|
    groups2[c] = group
  end
end
groups = groups2

MOVES = Hash.new { |h, k| h[k] = {} }
moves.each do |move1|
  moves.each do |move2|
    next unless move2.end == move1.end
    next if groups[move1.start].include?(move2.start)
    new_move = Move.new(move1.start, move2.start, move1.between + move2.between, move1.length + move2.length - 1)
    existing = MOVES[move1.start][move2.start]
    if !existing || new_move.length < existing.length
      MOVES[new_move.start][new_move.end] = new_move
    end
  end
end

puts MOVES.values.map(&:values).flatten.count

@best = 1_000_000

TARGETS = {
  "A" => "kjih",
  "B" => "onml",
  "C" => "srqp",
  "D" => "wvut",
}

def legal_move_from?(cells, from)
  type = cells[from]
  target = TARGETS[type]
  if target.include?(from)
    4.times do |i|
      if cells[target[i]] != type
        break
      elsif target[i] == from
        return false
      end
    end
  end
  true
end

def legal_move_to?(cells, from, to)
  return false if cells[to]
  MOVES[from][to].between.each_char do |c|
    return false if cells[c]
  end

  type = cells[from]
  target = TARGETS[type]
  if target.include?(to)
    4.times do |i|
      if cells[target[i]] != type
        return false
      elsif target[i] == to
        break
      end
    end
  elsif to > "g"
    return false
  end
  true
end

SOLUTION = {}
16.times do |i|
  SOLUTION["hijklmnopqrstuvw"[i]] = "AAAABBBBCCCCDDDD"[i]
end

SCORES = { "A" => 1, "B" => 10, "C" => 100, "D" => 1000 }

def recursive_solve(cells, score)
  if cells == SOLUTION
    @best = score if score < @best
    puts score
    return true
  end
  cells.keys.each do |from|
    value = cells[from]
    next unless legal_move_from?(cells, from)
    if "abcdefg".include?(from)
      possibilities = TARGETS[cells[from]]
    else
      possibilities = "abcdefg"
    end
    possibilities.each_char do |to|
      next unless legal_move_to?(cells, from, to)
      cells.delete(from)
      cells[to] = value
      recursive_solve(cells, score + SCORES[value] * MOVES[from][to].length)
      cells[from] = value
      cells.delete(to)
    end
  end
end

initial_state = {}
16.times do |i|
  initial_state["hijklmnopqrstuvw"[i]] = "ADDBDBCCCABBACAD"[i]
end

recursive_solve(initial_state, 0)
puts @best
puts "Finished in #{Time.now - @start_time} seconds."
