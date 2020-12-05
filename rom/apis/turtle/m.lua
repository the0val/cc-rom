function forward( n )
	if n == nil then n = 1 end
	for i = 1, n do
		while not turtle.forward() do
			turtle.dig()
			turtle.attack()
		end
	end
end

function up( n )
	if n == nil then n = 1 end
	for i = 1, n do
		while not turtle.up() do
			turtle.digUp()
			turtle.attackUp()
		end
	end
end

function down( n )
	if n == nil then n = 1 end
	for i = 1, n do
		while not turtle.down() do
			turtle.digDown()
			turtle.attackDown()
		end
	end
end

function back( n )
	if n == nil then n = 1 end
	local hasTurned = false
	for i = 1, n do
		if not turtle.back() then
			hasTurned = true
			turnLeft(2)
			forward(n - i + 1)
			turnLeft(2)
			break
		end
	end
end

function turnLeft( n )
	if n == nil then n = 1 end
	for i = 1, n do
		turtle.turnLeft()
	end
end
left = turnLeft

function turnRight( n )
	if n == nil then n = 1 end
	for i = 1, n do
		turtle.turnRight()
	end
end
right = turnRight

