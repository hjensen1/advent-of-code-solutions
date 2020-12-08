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

loop do
  line = @lines[@index]
  if @visited[@index]
    break
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

puts @acc
puts "Finished in #{Time.now - @start_time} seconds."
