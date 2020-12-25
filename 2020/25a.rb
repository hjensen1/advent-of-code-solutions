require '../util.rb'

def loop_size(target, subject)
  n = 1
  i = 1
  loop do
    n = (n * subject) % 20201227
    break if n == target
    i += 1
  end
  i
end

a = 3469259
b = 13170438

subject = 7

# as = loop_size(a, 7)
bs = loop_size(b, 7)

n = 1
(bs).times do
  n = (n * a) % 20201227
end

puts n
puts "Finished in #{Time.now - @start_time} seconds."
