local usage = [[
Usage: tunner <width> <height> [length]
]]

local opts, args = utils.parseArgs{ ...  }

local width, height, length = args[1], args[2], args[3]

if height == nil then
	print(usage)
	return
end

if length == nil then
	length = 1000000
end

m.forward()
turtle.turnRight()

local l = 1
while l < length do
	for w = 1, width do
		if w ~= 1 then
			m.forward()
		end
		if (width * w + l) % 2 == 0 then
			for i = 1, height - 1 do
				m.up()
			end
		else
			for i = 1, height - 1 do
				turtle.digDown()
				turtle.down()
			end
		end
	end
	if l % 2 == 1 then
		turtle.turnLeft()
		m.forward()
		turtle.turnLeft()
	else
		turtle.turnRight()
		m.forward()
		turtle.turnRight()
	end
	l = l + 1
end
