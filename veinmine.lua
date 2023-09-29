local s = require"smove"
local tArgs = { ... }

local found = false

-- Inspect in given direction (default forward) and save which block to
-- vein-mine in `targetBlock`
if tArgs[1] == "up" then
	local isBlock, data = turtle.inspectUp()
	if isBlock then
		s.targetBlock[data.name] = true
		found = true
	end
elseif tArgs[1] == "down" then
	local isBlock, data = turtle.inspectDown()
	if isBlock then
		s.targetBlock[data.name] = true
		found = true
	end
else
	local isBlock, data = turtle.inspect()
	if isBlock then
		s.targetBlock[data.name] = true
		found = true
	end
end

if not found then
	print"No block found"
	return
end



s.scanAll()
