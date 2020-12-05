-- Config
local branchLength = 30
local tunnelHeight = 7

function isOre( bool, data )
	return data.tags and data.tags["forge:ores"]
end

function inspect()
	if isOre(turtle.inspectUp()) then
		mineOre("up")
	end
	if isOre(turtle.inspectDown()) then
		mineOre("down")
	end
	for i=1,4 do
		if isOre(turtle.inspect()) then
			mineOre("forward")
		end
		m.left()
	end
end

function mineOre( moveDirection )
	moves = {
		forward = {m.forward, m.back},
		up = {m.up, m.down},
		down = {m.down, m.up},
	}
	moves[moveDirection][1]()
	inspect()
	moves[moveDirection][2]()
end

function branch()
	for i=1,branchLength do
		m.forward()
		inspect()
	end
	m.back(branchLength)
end

function tunnel()
	local i = 0
	while true do
		if i % 2 == 0 then
			for h=1,tunnelHeight do
				if ((i * 2) + h) % 5 == 1 then
					branch()
				end
				if h ~= tunnelHeight then
					m.up()
				end
			end
		else
			for h=tunnelHeight,1,-1 do
				if ((i * 2) + h) % 5 == 1 then
					branch()
				end
				if h ~= 1 then
					m.down()
				end
			end
		end
		m.right()
		m.forward()
		m.left()
		i = i + 1
	end
end

tunnel()
