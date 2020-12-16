require '../util.rb'

valid = [false] * 1000
phase = 1
sum = 0
File.read('./16.txt').split("\n").each do |line|
  if line == ''
    phase += 1
  elsif phase == 1
    field, rule = line.split(':')
    rules = rule.split(' or ')
    rules.map! { |s| s.split('-').map(&:to_i) }
    rules.each do |rule|
      (rule[0]..rule[1]).each { |x| valid[x] = true }
    end
  elsif phase == 2
    # do nothing
  elsif phase == 3
    values = line.split(',').map(&:to_i)
    sum += values.select { |value| !valid[value] }.sum
  else
    raise 'Bad Phase'
  end
end

puts sum
puts "Finished in #{Time.now - @start_time} seconds."
