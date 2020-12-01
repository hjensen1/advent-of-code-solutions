load '../util.rb'
load './classes.rb'

program = File.read('07.txt').chomp
max = 0
[0, 1, 2, 3, 4].permutation.each do |inputs|
  programs = {}
  (0..4).each do |id|
    programs[id] = {
      id: id,
      output_id: id + 1,
      process: IntcodeProcess.new(program, inputs: [inputs[id]])
    }
  end
  result = Processor.new(programs, 0, 4).start(inputs: [0])
  max = result.last if result.last > max
end

puts max
puts "Finished in #{Time.now - @start_time} seconds."
