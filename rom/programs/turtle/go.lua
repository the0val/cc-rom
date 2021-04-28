local opts, args = utils.parseArgs{ ... }

local usage = [[Usage:
go (<direction> [repeatN])...
]]

local doList = {}

-- Parses arguments
-- and places functions and repeatNs in doList
-- doList has is a list containing the repeatN and then function
-- this is the opposite order from how the arguments are passed
-- because it's easier in the next step this way.
local i = 1
while i < #args do
	local v = args[i]
	if tonumber(v) == nil then
		if #doList == 0 then
			utils.printError("Needs direction before number\n\n"..usage)
			return
		end
		table.insert(doList, #doList - 1, tonumber(v))
	end

	local switch = {
		forward = m.forward,
		f = m.forward,
		back = m.back,
		b = m.back,
		up = m.up,
		u = m.up,
		down = m.down,
		d = m.down,
		left = m.left,
		l = m.left,
		right = m.right,
		r = m.right,
	}
	local switchRes = switch[v]

	if switchRes == nil then
		utils.printError("Unknown argument "..v.."\n\n"..usage)
		return
	end
	table.insert(doList, switchRes)
end

-- calls every function in repeatN
-- with the argument of the preceding number
-- (or 1 if no number before it)
local repeatN = 1
for _,v in ipairs(doList) do
	if type(v) ~= "number" then
		v(repeatN)
		repeatN = 1
	else
		repeatN = v
	end
end
