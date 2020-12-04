require '../util.rb'

@required = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']

def valid?(line)
  parts = line.split(/[\n ]/).map { |s| s.split(':') }.map { |a| a[0] }
  @required.all? { |s| parts.include?(s) }
end

result = 0
File.read('./04.txt').split("\n\n").each do |line|
  result += 1 if valid?(line)
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
