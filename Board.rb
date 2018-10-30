class Board
	attr_accessor :board
	WHITE_BORDER = Gosu::Color.new(255, 255, 255, 255)
	RED_BORDER = Gosu::Color::RED
	BLUE_BACKGROUND = Gosu::Color.new(255, 66, 68, 120)
	def initialize(game, board)
		@game = game
		@board = board
		@font = Gosu::Font.new(20)
		@x = @y = 0
		@marked = []
		@stack = []
		@mode = :close
	end

	def draw
		@game.draw_quad(80, 0, BLUE_BACKGROUND, 560, 0, BLUE_BACKGROUND, 560, 480, BLUE_BACKGROUND, 80, 480, BLUE_BACKGROUND, 10)
		draw_border
		draw_lines
		draw_nums
	end

	def draw_border
		@game.draw_line(80, 0, WHITE_BORDER, 80, 480, WHITE_BORDER, 20)
		@game.draw_line(560, 0, WHITE_BORDER, 560, 480, WHITE_BORDER, 20)
		@game.draw_line(80, 1, WHITE_BORDER, 560, 1, WHITE_BORDER, 20)
		@game.draw_line(80, 480, WHITE_BORDER, 560, 480, WHITE_BORDER, 20)
	end

	def draw_lines
		i = 30
		while i < 560
			@game.draw_line(i, 0, WHITE_BORDER, i, 480, WHITE_BORDER, 20) if (i - 80) % 30 == 0 && i > 80 && (i - 80) % 120 != 0
			@game.draw_line(i, 0, RED_BORDER, i, 480, RED_BORDER, 10) if (i - 80) % 120 == 0
			@game.draw_line(80, i, WHITE_BORDER, 560, i, WHITE_BORDER, 20) if i % 30 == 0 && i < 480 && i % 120 != 0
			@game.draw_line(80, i, RED_BORDER, 560, i, RED_BORDER, 10) if i % 120 == 0
			i += 10
		end
	end

	def draw_nums
		for y in 0..@board.length - 1
			for x in 0..@board[0].length - 1
				@font.draw_rel(@board[y][x], x * 30 + 80 + 15, y * 30 + 15, 90, 0.5, 0.5, 1, 1) if @board[y][x] != '.'
			end
		end
	end

	def update
		if @y < 16 && @mode == :on
			sudoku_solver
			@x += 1
			if @x > 15
				@x = 0
				@y += 1
			end
		end
	end

	def sudoku_solver
		# x = y = 0
		# while y < @board.length                
			if @board[@y][@x] != '.'          
				# x += 1
				# if x > @board[0].length - 1
				# 	x = 0
				# 	y += 1
				# end
			else                           
				if !@marked.include?([@x, @y])
					@marked << [@x, @y]                       
					inputs = possible_inputs(@x, @y)  
					@stack << inputs                        
				end
				if @stack[-1].length == 0
					@stack.pop                           
					# break if stack.length == 0          
					@marked.pop
					@x = @marked[-1][0]                   
					@y = @marked[-1][1]
					@board[@y][@x] = '.'
					@x -= 1
					if @x < 0
						@y -= 1
						@x = 15
					end                  
				else
					@board[@y][@x] = @stack[-1].pop          # 向当前空格填入一个可填值，并在当前空格的可填值集合中删除这个值
					# input = stack[-1][rand(stack[-1].length)]
					# @board[y][x] = input
					# stack[-1].delete(input)
					# x += 1                               # 从这里开始继续遍历
					# if x > @board[0].length - 1
					# 	x = 0
					# 	y += 1
					# end
				end
			end
    # end
    # return (stack.length == 0) ? '当前数独无解' : @board
	end

	def possible_inputs(x, y)
    inputs = []
    for input in 1..@board.length
        inputs << input.to_s           # 向结果中加入所有数字
    end
    for i in 0..@board[y].length - 1
        next if @board[y][i] == '.'
        inputs.delete(@board[y][i]) if inputs.include?(@board[y][i])   # 去掉同一排中存在的数字
    end
    for j in 0..@board.length - 1
        next if @board[j][x] == '.'
        inputs.delete(@board[j][x]) if inputs.include?(@board[j][x])   # 去掉同一列中存在的数字
    end
    a = (@board.length ** 0.5).to_i
    m = y / a * a + x / a
    for n in 0..@board[0].length - 1
        index_y = n / a + m / a * a
        index_x = n % a + m % a * a
        next if @board[index_y][index_x] == '.'
        inputs.delete(@board[index_y][index_x]) if inputs.include?(@board[index_y][index_x])               # 去掉同一个宫中存在的数字
    end
		return inputs                                  # 返回剩余没有被去掉的数字，就是这个空格可以填的数字
	end

	def button_down(id)
		if id == Gosu::KB_A
			@mode = :on
		end
	end
end