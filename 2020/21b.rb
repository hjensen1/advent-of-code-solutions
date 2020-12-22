require '../util.rb'
require 'set'

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
end

solved = {}
while !ai.empty?
  ai.each_pair do |allergen, ingredients|
    if ingredients.size == 1
      i = ingredients.first
      solved[allergen] = i
      p [allergen, i]
      ai.values.each { |s| s.delete(i) }
      ai.delete(allergen) if ingredients.empty?
    end
  end
end

puts solved.to_a.sort_by { |x| x[0] }.map { |x| x[1] }.join(',')

puts "Finished in #{Time.now - @start_time} seconds."
