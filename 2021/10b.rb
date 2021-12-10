require '../util.rb'

lines = []
File.read('./10.txt').split("\n").each do |line|
  lines << line
end

@openers = { "{" => "}", "(" => ")", "[" => "]", "<" => ">" }
@closers = @openers.invert
@scores = { ")" => 1, "]" => 2, "}" => 3, ">" => 4 }

def check_incomplete(line)
  stack = []
  (0...line.size).each do |i|
    c = line[i]
    stack << c if @openers[c]
    if @closers[c]
      if stack.last == @closers[c]
        stack.pop
      else
        return false
      end
    end
  end
  stack
end


scores = lines.map do |line|
  if stack = check_incomplete(line)
    # pp stack
    # pp stack.reverse.map { |x| @openers[x] }.join
    score = 0
    stack.reverse.each do |opener|
      score *= 5
      score += @scores[@openers[opener]]
    end
    # p score
    score
  end
end.compact

p scores.sort[scores.size / 2]
puts "Finished in #{Time.now - @start_time} seconds."
