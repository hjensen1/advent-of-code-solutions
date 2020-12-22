require '../util.rb'
require 'set'

p1 = []
p2 = []
File.read('./22.txt').split("\n\n").each_with_index do |section, p|
  lines = section.split("\n")
  lines.shift
  p = p == 0 ? p1 : p2
  p.concat(lines.map(&:to_i))
end

@games = 0

def reduce(array, start = 0)
  array.reduce(start) { |result, x| (result << 8) + x }
end

def do_game(p1, p2)
  @games += 1
  # puts "Game #{@games}"
  states = Set.new
  turn = 0
  while !p1.empty? && !p2.empty?
    key = reduce(p1)
    key = reduce(p2, key << 8)
    if states.include?(key)
      return 1
    end
    states << key
    do_round(p1, p2, turn += 1)
  end
  p1.empty? ? 2 : 1
end

def do_round(p1, p2, turn)
  # puts "Turn #{turn}"
  # p p1
  # p p2
  p1_card = p1.shift
  p2_card = p2.shift
  if p1.size >= p1_card && p2.size >= p2_card
    result = do_game(p1[0, p1_card], p2[0, p2_card])
  elsif p2_card > p1_card
    result = 2
  else
    result = 1
  end
  if result == 2
    p2 << p2_card
    p2 << p1_card
  else
    p1 << p1_card
    p1 << p2_card
  end
end

do_game(p1, p2)

winner = p1.empty? ? p2 : p1

sum = 0
winner.reverse.each_with_index { |x, i| sum += x * (i + 1) }
puts sum

puts "Finished in #{Time.now - @start_time} seconds."
