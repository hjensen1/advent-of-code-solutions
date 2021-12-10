require '../util.rb'

lines = []
File.read('./10.txt').split("\n").each do |line|
  lines << line
end

@openers = { "{" => "}", "(" => ")", "[" => "]", "<" => ">" }
@closers = @openers.invert
@scores = { ")" => 3, "]" => 57, "}" => 1197, ">" => 25137 }

def check_corrupted(line)
  stack = []
  (0...line.size).each do |i|
    c = line[i]
    if @openers[c]
      stack << c
    end
    if @closers[c]
      if stack.last == @closers[c]
        stack.pop
      else
        return @scores[c]
      end
    end
  end
  0
end

puts lines.sum { |line| check_corrupted(line) }
puts "Finished in #{Time.now - @start_time} seconds."
