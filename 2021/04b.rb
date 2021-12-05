require '../util.rb'

result = 0
boards = File.read('./04.txt').split("\n\n")
numbers = boards.shift.split(",").map(&:to_i)
boards = boards.map { |string| string.split("\n").map{ |l| l.strip.split(/\W+/).map(&:to_i) } }

def mark_board(board, number)
  (0...5).each do |i|
    (0...5).each do |j|
      board[i][j] = nil if board[i][j] == number
    end
  end
end

def check_board(board)
  (0...5).each do |i|
    return true if board[i].all? { |n| n == nil }
    return true if board.transpose[i].all? { |n| n == nil }
  end
  false
end

def run(numbers, boards)
  numbers.each do |n|
    boards.each do |board|
      mark_board(board, n)
      if check_board(board)
        if boards.size > 1
          boards = boards.reject { |b| b == board }
        else
          return boards[0].map { |line| line.map(&:to_i).sum }.sum * n
        end
      end
    end
  end
  nil
end

p run(numbers, boards)
puts "Finished in #{Time.now - @start_time} seconds."
