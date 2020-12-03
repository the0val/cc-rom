os.loadAPI"utils.lua"
local saplingslot = 1
local logPattern = "log"
local flags = utils.parseArgs({...})

local function log()
	local bool, block = turtle.inspectUp()
	if bool and string.match(block.name, logPattern) then
		turtle.digUp()
		turtle.up()
		log()
		turtle.down()
	end
end

local function plant()
	turtle.select(saplingslot)
	if not turtle.place() then
		print"out of items"
		brun = false
	end
end

local function tree()
	local bool, block = turtle.inspect()
	if not bool then
		plant()
	elseif string.match(block.name, logPattern) then
		turtle.dig()
		turtle.forward()
		log()
		turtle.back()
		plant()
	end
end

local brun = true
while brun do
	if flags["around"] then
		for i = 1,4 do
			tree()
			turtle.turnLeft()
		end
	else
		tree()
	end
	sleep(15)
end
