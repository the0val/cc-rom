function parseArgs( args )
	local options = {}
	local arguments = {}
	for _, word in ipairs(args) do
		local dubbleDashOption = word:match("^%-%-(%a+)$")
		local singleDashOption = word:match("^%-(%a+)$")
		if dubbleDashOption then
			options[dubbleDashOption] = true
		elseif singleDashOption then
			for c in singleDashOption:gmatch"." do
				options[c] = true
			end
		else
			table.insert(arguments, word)
		end
	end
	return options, arguments
end
