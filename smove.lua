local s = {}

-- Saves info about the turtles position and other relevant state.
-- Is continually saved to disk through metatables and `saveState` function.
-- Fields:
--   x (int) x-pos
--   y (int) y-pos
--   z (int) z-pos
--   facing (int) direction facing 0=north,1=east,2=south,3=west
s.state = {}

local saveState
do
	-- Holds underlying data for `s.state`.
	local stateData = {x=0,y=0,z=0,facing=0}

	function saveState(_, key, value)
		stateData[key] = value
		-- TODO write to file
		local f = fs.open(".state", "w")
		f.write(string.format("%d\n%d\n%d\n%d", stateData.x, stateData.y, stateData.z, stateData.facing))
		f.close()
	end

	setmetatable(s.state, {__index = stateData, __newindex = saveState})
end

local directionMatrixes = {
	[0] = {x=0,y=0,z=-1}, -- North
	[1] = {x=1,y=0,z=0},  -- East
	[2] = {x=0,y=0,z=1},  -- South
	[3] = {x=-1,y=0,z=0}, -- West
	["up"] = {x=0,y=1,z=0},
	["down"] = {x=0,y=-1,z=0}
}

local function saveMove(direction)
	s.state.x = s.state.x + directionMatrixes[direction].x
	s.state.y = s.state.y + directionMatrixes[direction].y
	s.state.z = s.state.z + directionMatrixes[direction].z
end

--------------------
-- Basic movement --
--------------------

function s.forward(n)
	for _ = 1, n or 1 do
		while not turtle.forward() do
			turtle.dig()
			turtle.attack()
		end
		saveMove(s.state.facing)
	end
end

function s.up(n)
	for _ = 1, n or 1 do
		while not turtle.up() do
			turtle.digUp()
			turtle.attackUp()
		end
		saveMove("up")
	end
end

function s.down(n)
	for _ = 1, n or 1 do
		while not turtle.down() do
			turtle.digDown()
			turtle.attackDown()
		end
		saveMove("down")
	end
end

function s.back(n)
	n = n or 1
	for i = 1, n do
		if not turtle.back() then
			turtle.turnLeft()
			turtle.turnLeft()
			s.forward(n - i + 1)
			turtle.turnLeft()
			turtle.turnLeft()
			break
		end
		saveMove((s.state.facing + 2) % 4)
	end
end

function s.left()
	s.state.facing = (s.state.facing + 3) % 4
	turtle.turnLeft()
end

function s.right()
	s.state.facing = (s.state.facing + 1) % 4
	turtle.turnRight()
end

-----------------
-- Vein mining --
-----------------

s.targetBlock = {}

local function istargetBlock()
	local isBlock, data = turtle.inspect()
	return isBlock and s.targetBlock[data.name]
end

local function istargetBlockUp()
	local isBlock, data = turtle.inspectUp()
	return isBlock and s.targetBlock[data.name]
end

local function istargetBlockDown()
	local isBlock, data = turtle.inspectDown()
	return isBlock and s.targetBlock[data.name]
end

-- Scan above and below for `s.targetBlock`
local function scanVertical()
	if istargetBlockUp() then
		s.up()
		s.scanAll()
		s.down()
	end
	if istargetBlockDown() then
		s.down()
		s.scanAll()
		s.up()
	end
end

function s.scanFast()
	scanVertical()
	if istargetBlock() then
		s.forward()
		s.scanAll()
		s.back()
	end
end

-- Scan all around for `s.targetBlock`
function s.scanAll()
	scanVertical()
	for _ = 1,4 do
		if istargetBlock() then
			s.forward()
			s.scanAll()
			s.back()
		end
		turtle.turnLeft()
	end
end

-- Read ores from file
do
	local f = fs.open("ores", "r")
	while true do
		local line = f.readLine()

		if not line then break end

		s.targetBlock[line] = true
	end
end


-- Initialize state from file
-- TODO

return s
