require '../util.rb'

result = 0
raw = {}
lines = []
ps = File.read('./19.txt').split("\n\n")
ps[0].split("\n").each do |rule|
  parts = rule.split(': ')
  raw[parts[0].to_i] = parts[1].gsub('"', '')
end

complete = Array.new(200)
while !raw.empty?
  raw.each_pair do |rulenum, text|
    if /^[ab()| ]+$/.match(text)
      complete[rulenum] = text
      raw.delete(rulenum)
      next
    end
    parts = text.split(' ')
    regex = ['']
    parts.each_with_index do |part, index|
      if /^\d+$/.match(part)
        if complete[part.to_i]
          parts[index] = complete[part.to_i].include?('|') ? "(#{complete[part.to_i]})" : complete[part.to_i]
        end
      end
    end
    raw[rulenum] = parts.join(' ')
  end
end

complete.map! { |rule| rule && Regexp.new("^#{rule.gsub(' ', '')}$") }

ps[1].split("\n").each do |line|
  result += 1 if complete[0].match(line)
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
