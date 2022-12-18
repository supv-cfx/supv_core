local math <const>, type <const>, tonumber <const> = math, type, tonumber

--- math.round
---
---@param num number
---@param numDecimalPlaces? number
---@return number
local function Round(num, numDecimalPlaces)
    return tonumber(string.format("%."..(numDecimalPlaces or 0).."f", num))
end

--- math.chance
---
---@param percent number
---@param cb? function
---@return boolean
local function Chance(percent, cb)
    if type(percent) ~= 'number' then return end
    if percent < 1 then return false end
    if percent > 99 then return true end
    local result = math.random(1,100)
    if cb then
        cb(result)
    end
    return result <= percent
end

 --retourne une valeur sur 2 digit (exemple 1 retourne 01)
 local function deuxDigits(nombre)
	nombre = string.format("%02d",nombre)
	return nombre
end

--convertit un temps (en seconde) en SEM JJ HH MM SS
local function format_temps(sec, value)
 --valeur possible semaine, jour, heure, minute ou seconde
	local sem, jj, hh, mm, ss, reste = 0, 0, 0, 0, 0
	if value ~= nil then
		if value == 'semaine' then
			sem = math.floor(sec/(60*60*24*7))
			reste = sec%604800
			jj = math.floor(reste/(60*60*24))
			reste = (reste%86400)
			hh = math.floor(reste/(60*60))
			reste = (reste%3600)
			mm = math.floor(reste/60)
			ss = (reste%60)
		elseif value == 'jour' then
			jj = math.floor(sec/(60*60*24))
			reste = (sec%86400)
			hh = math.floor(reste/(60*60))
			reste = (reste%3600)
			mm = math.floor(reste/60)
			ss = (reste%60)
		elseif value == 'heure' then
			hh = math.floor(sec/(60*60))
			reste = (sec%3600)
			mm = math.floor(reste/60)
			ss = (reste%60)
		elseif value == 'minute' then
			mm = math.floor(sec/60)
			reste = (sec%60)
			ss = (reste)
		elseif value == 'seconde' then
			ss = sec
		end
	end
	return sem, jj, deuxDigits(hh), deuxDigits(mm), deuxDigits(ss)
end

return {
    round = Round,
    chance = Chance,
    doubleDigits = deuxDigits,
    time = format_temps
}