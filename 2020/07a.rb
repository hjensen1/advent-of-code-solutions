require '../util.rb'

@rules = Hash.new { |h, k| h[k] = [] }

def parse_rule(line)
  parts = line.split(/, |contain /)
  parts.map! { |s| s.gsub(/ bag.*$/, '') }
  container = parts.shift
  parts.each do |s|
    x = /(\d+ )?(.+)/.match(s)
    @rules[x[2]] << [x[1].to_i, container]
  end
end

result = 0
File.read('./07.txt').split("\n").each do |line|
  parse_rule(line)
end

def stuff(color, list)
  (@rules[color] || []).each do |_, color2|
    list[color2] = true
    stuff(color2, list)
  end
  list
end

puts stuff('shiny gold', {}).size
puts "Finished in #{Time.now - @start_time} seconds."
