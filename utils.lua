local utils = {}
function utils.parseArgs( args )
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

function utils.printError( message )
	if term.setTextColor then
		term.SetTextColor(colors.red)
	end
	print("Error:\n", message)
	if term.setTextColor then
		term.SetTextColor(colors.white)
	end
end

return utils
