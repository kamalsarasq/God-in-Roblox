local module = {}

-- // FUNCTION TO CHECK IF IT HAS THE KEYWORD GOD //
module.hasGodWord = function(str: string, keyword: string): boolean
	return string.find(str:lower(), keyword)
end

return module
