require '../util.rb'

result = 0
raw = {}
lines = []
ps = File.read('./19.txt').split("\n\n")
ps[0].split("\n").each do |rule|
  parts = rule.split(': ')
  raw[parts[0].to_i] = parts[1].gsub('"', '')
end

rules = {}
while !raw.empty?
  changed = false
  raw.each_pair do |rulenum, text|
    if /^[ab()| ]+$/.match(text)
      rules[rulenum] = text
      raw.delete(rulenum)
      changed = true
      next
    end
    parts = text.split(' ')
    regex = ['']
    parts.each_with_index do |part, index|
      if /^\d+$/.match(part)
        if rules[part.to_i]
          changed = true
          parts[index] = rules[part.to_i].include?('|') ? "(#{rules[part.to_i]})" : rules[part.to_i]
        end
      end
    end
    raw[rulenum] = parts.join(' ')
  end
  break if changed == false
end

rules.each_pair { |id, rule| rules[id] = rule.gsub(' ', '') }
@list = (1..10).map { |i| Regexp.new("^(#{rules[42]}){#{i+1}}(#{rules[31]}){1,#{i}}$") }

ps[1].split("\n").each do |line|
  result += 1 if @list.any? { |regex| regex.match(line) }
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
