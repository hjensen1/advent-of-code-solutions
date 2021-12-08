require '../util.rb'

cases = []
File.read('./08.txt').split("\n").each do |line|
  parts = line.split(" | ")
  cases << {
    digits: parts[0].split(" "),
    output: parts[1].split(" "),
  }
end

sum = cases.map do |c|
  pp c[:output].select { |x| [2,3,4,7].include?(x.size) }.count
end.sum
p sum

puts "Finished in #{Time.now - @start_time} seconds."
