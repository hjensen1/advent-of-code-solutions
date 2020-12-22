require '../util.rb'
require 'set'

Food = Struct.new(:ingredients, :allergens)

foods = []
ia = Hash.new {}
ai = Hash.new {}
File.read('./21.txt').split("\n").each do |line|
  parts = line.split(/[()]/)
  ingredients = parts[0].split(' ')
  allergens = parts[1].gsub('contains ', '').split(', ')

  allergens.each do |a|
    if ai.key?(a)
      ai[a] = ai[a] & ingredients
    else
      ai[a] = Set.new(ingredients)
    end
  end

  foods << Food.new(ingredients, allergens)
end

pp ai

result = 0
foods.each do |food|
  food.ingredients.each do |ingredient|
    result += 1 unless ai.values.any? { |s| s.include?(ingredient) }
  end
end
puts result

puts "Finished in #{Time.now - @start_time} seconds."
