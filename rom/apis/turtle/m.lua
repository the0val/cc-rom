function forward()
	while not turtle.forward() do
		turtle.dig()
	end
end

function up()
	while not turtle.up() do
		turtle.digUp()
	end
end
