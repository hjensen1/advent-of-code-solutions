require '../util.rb'

fishes = File.read('./06.txt').split(",").map(&:to_i)

80.times do
  newFishes = 0
  fishes.each_with_index do |fish, i|
    if (fish == 0)
      newFishes += 1
      fishes[i] = 6
    else
      fishes[i] -= 1
    end
  end
  fishes += [8] * newFishes
end

puts fishes.size
puts "Finished in #{Time.now - @start_time} seconds."
