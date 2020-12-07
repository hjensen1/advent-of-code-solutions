require '../util.rb'

@rules = Hash.new { |h, k| h[k] = [] }

def parse_rule(line)
  parts = line.split(/, |contain /)
  parts.map! { |s| s.gsub(/ bag.*$/, '') }
  container = parts.shift
  parts.each do |s|
    x = /(\d+ )?(.+)/.match(s)
    @rules[container] << [x[1].to_i, x[2]]
  end
end

result = 0
File.read('./07.txt').split("\n").each do |line|
  parse_rule(line)
end

def stuff(color)
  count = 0
  (@rules[color] || []).each do |x, color2|
    count += x + x * stuff(color2)
  end
  count
end

puts stuff('shiny gold')
puts "Finished in #{Time.now - @start_time} seconds."
