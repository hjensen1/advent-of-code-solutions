require '../util.rb'
require './classes.rb'

program = File.read('./09.txt').chomp
process = IntcodeProcess.new(program, inputs: [1])
output = process.start
puts "#{process.steps} steps"

puts output
puts "Finished in #{Time.now - @start_time} seconds."
