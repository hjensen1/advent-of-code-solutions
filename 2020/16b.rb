require '../util.rb'
require 'set'

rules = {}
possible = {}
valid_values = [false] * 1000
phase = 1
my_ticket = []
File.read('./16.txt').split("\n").each do |line|
  if line == ''
    phase += 1

  elsif phase == 1
    field, rule = line.split(':')
    rule = rule.split(' or ')
    rule.map! { |s| s.split('-').map(&:to_i) }
    rules[field] = rule
    rule.each do |r|
      (r[0]..r[1]).each { |x| valid_values[x] = true }
    end

  elsif phase == 2
    rules.keys.each { |key| possible[key] = Set.new((0...(rules.size))) }
    my_ticket = line.split(',').map(&:to_i)

  elsif phase == 3
    values = line.split(',').map(&:to_i)
    next if values.any? { |value| !valid_values[value] }
    values.each_with_index do |value, index|
      rules.each_pair do |name, rules|
        if (value < rules[0][0] || value > rules[0][1]) && (value < rules[1][0] || value > rules[1][1])
          possible[name].delete(index)
        end
      end
    end

  else
    raise 'Bad Phase'
  end
end

confirmed = {}
while !possible.empty?
  possible.each_pair do |key, values|
    if values.size == 0
      raise 'No possibilities'
    elsif values.size == 1
      possible.delete(key)
      confirmed[key] = values.first
      possible.values.each { |remaining| remaining.delete(values.first) }
    end
  end
end

result = 1
hash = {}
confirmed.each_pair do |key, value|
  hash[key] = my_ticket[value]
  if key.start_with?('departure')
    result *= my_ticket[value]
  end
end
pp hash

puts result
puts "Finished in #{Time.now - @start_time} seconds."
