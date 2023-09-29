--[[
	Flattens an area of the given dimensions
	height (default up) width (default left) length (default forward)
	Width is counted to the left from the turtle

	**Options**
	-u : (default) Will dig upwards. Opposite of -d
	-d : Will dig down. Opposite of -u

	-l : (default) Will dig to the left. Opposite of -r
	-r : Will dig to the right. Opposite of -l
]]

-- Handle command line arguments --

utils = require"utils"
local opts, args = utils.parseArgs({...})
local height = tonumber(args[1])
local width = tonumber(args[2])
local length = tonumber(args[3])
if not (height and width and length) then
	print("Usage: flatten [options] <height> <width> <length>")
	return
end

if opts.d then
	turtle.up, turtle.down = turtle.down, turtle.up
	turtle.digUp = turtle.digDown
end
if opts.r then
	turtle.turnLeft, turtle.turnRight = turtle.turnRight, turtle.turnLeft
end

-- Functions --

local function sForward()
	-- Moves the turtle forward and removes any blocks or kills mobs that are in the way
	while not turtle.forward() do
		turtle.dig()
		turtle.attack()
	end
end

-- Loop start here --

for h = 0, height-1 do
	for w = 1, width do
		for l = 1, length-1 do
			sForward()
		end
		if w ~= width then
			-- Every time except for the last row on every level
			-- the turtle will move to the start of the next row
			if (w + h * (width - 1)) % 2 == 1 then
				turtle.turnLeft()
				sForward()
				turtle.turnLeft()
			else
				turtle.turnRight()
				sForward()
				turtle.turnRight()
			end
		end
	end
	if h ~= height-1 then
		turtle.turnLeft()
		turtle.turnLeft()
		while not turtle.up() do
			turtle.digUp()
		end
	end
end

-- Return to starting position
for h = 2, height do
	turtle.down()
end
if (height * width) % 2 == 1 then
	-- If (height * width) is even then turtle will be on the
	-- starting row (lenthwise). Otherwise, it needs to go back
	turtle.turnRight()
	turtle.turnRight()
	for l = 2, length do
		turtle.forward()
	end
end
if height % 2 == 1 then
	-- If height is even, then turtle will end at the starting
	-- row (widthwise). Otherwise, it needs to go right.
	turtle.turnLeft()
	for w = 2, width do
		turtle.forward()
	end
	turtle.turnLeft()
else
	turtle.turnLeft()
	turtle.turnLeft()
end
