class Matrix
	def initialize(file)
		@size = 0
		@data = []
		fill_matrix_from_file(file)
	end

	def size
		@size
	end

	def [](r)
		@data[r]
	end

	def fill_matrix_from_file(file)
		file = File.open(file, "r")
		@size = IO.readlines(file)[0].chomp.to_i
		for n in (1..@size)
			line = IO.readlines(file)[n].split(" ").map(&:to_i)
			@data.push(line)
		end
	end

	def print_matrix
		@data.each do |line|
			line.each do |elem|
				print sprintf(" %-3i ", elem)
			end
			puts 
		end
	end

	def get_row(n)
		@data[n]
	end

	def to_power(power)
		while power!=1
			r = Array.new(@size) {Array.new(@size)}
			for row in 0...@size
				for col in 0...@size
					r[row][col] = 0
				end
			end
			for row in 0...@size
				for col in 0...@size
					for i in 0...@size
						r[row][col] += @data[row][i] * @data[i][col]
					end
				end
			end
			@data = r
			power-=1
		end
	end
end


class Test

	def initialize(file)
		@matrix = Matrix.new(file)
		@zeroes = []
		remember_zeroes
	end

	def remember_zeroes
		for row in 0...@matrix.size
			for col in 0...@matrix.size
				if @matrix[row][col] == 0
					@zeroes.push([row, col])
				end
			end
		end
	end

	def remove_zeroes
		not_zeroes = []
		@zeroes.each do |a|
			row = a[0]
			col = a[1]
			if @matrix[row][col] != 0
				not_zeroes.push([row, col])
			end
		end
		@zeroes -= not_zeroes
	end

	def connected?
		is_connected = false
		for power in 2..@matrix.size
			@matrix.to_power(power)
			remove_zeroes
			if @zeroes.empty? 
				is_connected = true
				break
			end
		end
		return is_connected
	end

	def run
		puts connected? ? "connected" : "disconnected"
	end
end

test = Test.new("test0.txt")
test.run
