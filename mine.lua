local s = require"smove"
local utils = require"utils"

local usage = [[
Usage: mine [tunnelHeight] [branchLength]
]]

local _, args = utils.parseArgs{...}
if #args < 2 then
	error(usage)
end
local tunnelHeight = tonumber(args[1])
local branchLength = tonumber(args[2])

-- Read ores from file
do
	local f = fs.open("ores", "r")
	while true do
		local line = f.readLine()

		if not line then break end

		s.targetBlock[line] = true
	end
end

local function branch()
	s.scanFast()
	for _ = 1, branchLength do
		s.forward()
		s.scanFast()
	end
	s.back(branchLength)
end

local function inventoryDrop(l)
	-- Use any burnable items to refuel
	shell.run"refuel all"
	-- Check if inventory is half full
	local availableSlots = 0
	for i = 1, 16 do
		if turtle.getItemCount(i) == 0 then
			availableSlots = availableSlots + 1
		end
	end

	if availableSlots > 9 then
		return false
	end

	-- Do drop
	s.right()
	s.back(l)
	for i = 1, 16 do
		turtle.select(i)
		turtle.dropDown()
	end
	turtle.select(1)
	s.forward(l)
	s.left()
	return true
end

local function tunnel()
	local l = 0
	while true do
		for h = 0, tunnelHeight-2 do
			if (h - (l % 2)) % 4 == 0 then
				branch()
			end
			s.up()
		end
		s.down(tunnelHeight-1)
		s.right()
		s.forward()
		s.left()
		l = l + 1
		inventoryDrop(l)
	end
end

tunnel()
