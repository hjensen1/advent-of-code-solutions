require '../util.rb'

Blueprint = Struct.new(:id, :ore_ore, :clay_ore, :obsidian_ore, :obsidian_clay, :geode_ore, :geode_obsidian) do
  def self.parse(string)
    Blueprint.new(*string.scan(/\d+/).to_a.map(&:to_i))
  end
end

blueprints = []
File.read('./19.txt').split("\n").each do |line|
  blueprints << Blueprint.parse(line)
end

State = Struct.new(:minutes, :ore, :clay, :obsidian, :geodes, :ore_robots, :clay_robots, :obsidian_robots, :geode_robots) do
  def self.base_state
    State.new(24, 0, 0, 0, 0, 1, 0, 0, 0)
  end

  def next_step
    self.ore += ore_robots
    self.clay += clay_robots
    self.obsidian += obsidian_robots
    self.geodes += geode_robots
    self.minutes -= 1
  end

  def undo_step
    self.ore -= ore_robots
    self.clay -= clay_robots
    self.obsidian -= obsidian_robots
    self.geodes -= geode_robots
    self.minutes += 1
  end

  def can_build_ore?
    ore >= blueprint.ore_ore
  end

  def build_ore
    self.ore -= blueprint.ore_ore
    self.ore_robots += 1
  end

  def unbuild_ore
    self.ore += blueprint.ore_ore
    self.ore_robots -= 1
  end

  def can_build_clay?
    ore >= blueprint.clay_ore
  end

  def build_clay
    self.ore -= blueprint.clay_ore
    self.clay_robots += 1
  end

  def unbuild_clay
    self.ore += blueprint.clay_ore
    self.clay_robots -= 1
  end

  def can_build_obsidian?
    ore >= blueprint.obsidian_ore && clay >= blueprint.obsidian_clay
  end

  def build_obsidian
    self.ore -= blueprint.obsidian_ore
    self.clay -= blueprint.obsidian_clay
    self.obsidian_robots += 1
  end

  def unbuild_obsidian
    self.ore += blueprint.obsidian_ore
    self.clay += blueprint.obsidian_clay
    self.obsidian_robots -= 1
  end

  def can_build_geode?
    ore >= blueprint.geode_ore && obsidian >= blueprint.geode_obsidian
  end

  def build_geode
    self.ore -= blueprint.geode_ore
    self.obsidian -= blueprint.geode_obsidian
    self.geode_robots += 1
  end

  def unbuild_geode
    self.ore += blueprint.geode_ore
    self.obsidian += blueprint.geode_obsidian
    self.geode_robots -= 1
  end

  def done?
    minutes == 0
  end

  def blueprint
    State.blueprint
  end

  class << self
    attr_accessor :blueprint
  end
end

@best = 0
@cache_hits = 0
def find_best(state, cache)
  use_cache = state.minutes % 4 == 0
  if state.done?
    return state.geodes
  elsif use_cache && cache[state.minutes][state]
    @cache_hits += 1
    # p "cache_size: #{cache.sum(&:size)}, cache_hits: #{@cache_hits}" if @cache_hits % 1000 == 0
    return cache[state.minutes][state]
  end
  best = ['geode', 'obsidian', 'clay', 'ore', nil].map do |type|
    if type.nil? || state.send("can_build_#{type}?")
      recursive_step(state, cache, type)
    else
      state.geodes
    end
  end.max
  if best > @best
    @best = best
    puts best
  end
  if use_cache
    cache[state.minutes][state.dup] = best
  else
    best
  end
end

def recursive_step(state, cache, type)
  state.next_step
  state.send("build_#{type}") if type
  best = find_best(state, cache)
  state.send("unbuild_#{type}") if type
  state.undo_step
  best
end

result = blueprints.sum do |blueprint|
  State.blueprint = blueprint
  @best = 0
  best = find_best(State.base_state, Array.new(25) { {} })
  best * blueprint.id
end

puts result
puts "Finished in #{Time.now - @start_time} seconds."
