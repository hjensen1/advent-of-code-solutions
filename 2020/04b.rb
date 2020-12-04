require '../util.rb'

@required = ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']

def valid?(line)
  data = Hash[line.split(/[\n ]/).map { |s| s.split(':') }]
  return false unless @required.all? { |s| data[s] }

  exp = data['byr'].length == 4 && data['byr'].to_i >= 1920 && data['byr'].to_i <= 2002 &&
    data['iyr'].length == 4 && data['iyr'].to_i >= 2010 && data['iyr'].to_i <= 2020 &&
    data['eyr'].length == 4 && data['eyr'].to_i >= 2020 && data['eyr'].to_i <= 2030 &&

  if data['hgt'].match(/^\d+in$/)
    height = data['hgt'].to_i >= 59 && data['hgt'].to_i <= 76
  elsif data['hgt'].match(/^\d+cm$/)
    height = data['hgt'].to_i >= 150 && data['hgt'].to_i <= 193
  else
    return false
  end

  hair = data['hcl'].match(/^#[0-9a-f]{6}$/)
  eye = 'amb blu brn gry grn hzl oth'.split(' ').include?(data['ecl'])
  pid = data['pid'].match(/^\d{9}$/)

  exp && height && hair && eye && pid
end

result = 0
File.read('./04.txt').split("\n\n").each do |line|
  result += 1 if valid?(line)
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
