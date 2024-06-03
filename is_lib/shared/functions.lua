Lib.debug = function(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for _ = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k, v in pairs(table) do
			if type(k) ~= 'number' then k = '"' .. k .. '"' end
			for _ = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '[' .. k .. '] = ' .. Lib.debug(v, nb + 1) .. ',\n'
		end

		for _ = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

Lib.refInt = function(int)
	return tostring(int):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

Lib.missingValue = function(num1, num2)
	return math.floor(num1 - num2)
end

Lib.roundTo = function(int, round)
	return tonumber(string.format("%."..round.."f", int))
end

Lib.checkSuccess = function(chance)
	local randomNumber = math.random() * 100
    	return randomNumber <= chance
end

Lib.getRandomString = function(length)
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local randomString = ""

    for i = 1, length do
        local randomIndex = math.random(#chars)
        local randomChar = chars:sub(randomIndex, randomIndex)
        randomString = randomString .. randomChar
    end

    return randomString
end

Lib.isExportAvailable = function(resource, exportName)
	if GetResourceState(resource) ~= "started" then return false end

    local exportAvailable = nil
    local status, err = pcall(function()
        exportAvailable = exports[resource][exportName]
    end)

    return status and exportAvailable ~= nil
end
