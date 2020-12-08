require '../util.rb'

@index = 0
@acc = 0
@lines = []
@visited = {}

File.read('./08.txt').split("\n").each do |line|
  parts = line.split(' ')
  parts[1] = parts[1].to_i
  @lines << parts
end

def valid?
  @acc = 0
  @index = 0
  @visited = {}
  loop do
    line = @lines[@index]
    if @index == @lines.size
      return true
    end
    if @visited[@index]
      return false
    end
    @visited[@index] = true
    if line[0] == 'acc'
      @acc += line[1]
      @index += 1
    elsif line[0] == 'nop'
      @index += 1
    elsif line[0] == 'jmp'
      @index += line[1]
    else
      raise 'bad'
    end
  end
end

lines.each do |line|
  if line[0] == 'nop'
    line[0] = 'jmp'
    break if valid?
    line[0] = 'nop'
  elsif line[0] == 'jmp'
    line[0] = 'nop'
    break if valid?
    line[0] = 'jmp'
  end
end


puts @acc
puts "Finished in #{Time.now - @start_time} seconds."
