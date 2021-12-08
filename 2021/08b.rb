require '../util.rb'

cases = File.read('./08.txt').split("\n").map do |line|
  line.split(" | ").map(&:split)
end

@digits = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]
@sorted = @digits.sort
@letters = ["a","b","c","d","e","f","g"]

sum = cases.sum do |c|
  map = @letters.permutation(7).find do |letters|
    input = c[0].map { |s| s.tr("abcdefg", letters.join).chars.sort.join }
    input.sort == @sorted
  end
  c[1].map { |s| s.tr("abcdefg", map.join).chars.sort.join }.map { |x| @digits.find_index(x).to_s }.join.to_i
end

puts sum
puts "Finished in #{Time.now - @start_time} seconds."
